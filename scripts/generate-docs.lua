local insert = table.insert
local sort = table.sort
local concat = table.concat
local fmt = string.format

local script_path = debug.getinfo(1, "S").source:gsub("^@", "")
local script_dir = script_path:match("^(.*)/[^/]*$") or "."
local lls = dofile(script_dir .. "/luals-type-parser.lua")

local config = dofile(script_dir .. "/config.lua")
local ignored_stems = {}
for _, stem in ipairs(config.ignored_stems or {}) do
  ignored_stems[stem] = true
end
local FIELD_OVERVIEW_MIN = config.FIELD_OVERVIEW_MIN
local github_org = config.github_org or "BlueLua"
local github_types_dir = config.github_types_dir or "types"
local github_types_url_template = "https://github.com/"
  .. github_org
  .. "/%s/blob/main/"
  .. github_types_dir
  .. "/%s#L%d-L%d"
local domain = config.domain or "bluelua.github.io"
local escaped_domain = domain:gsub("%.", "%%.")
local internal_link_pattern = "https?://" .. escaped_domain .. "/([^%s%)%\"%'%>]+)"
local api_dir_name = config.api_dir_name or "api"
local types_file_name = config.types_file_name or "types"
local function page_stem(filename)
  return filename:gsub("%.d%.lua$", ""):gsub("%.lua$", ""):lower()
end
local link_refs = {}
local types_dir, output_dir

local has_ffi, ffi = pcall(require, "ffi")
if has_ffi then
  ffi.cdef [[
    int access(const char *pathname, int mode);
    int mkdir(const char *pathname, unsigned int mode);
  ]]
end

local function shell_quote(s)
  return "'" .. tostring(s):gsub("'", [['"'"']]) .. "'"
end

local function exists_dir(path)
  if has_ffi then
    return ffi.C.access(path .. "/.", 0) == 0
  else
    local f = io.open(path .. "/.", "r")
    if f then
      f:close()
      return true
    end
    return false
  end
end

local function is_valid_module(module)
  if not module then
    return false
  end
  local std_types = {
    string = true,
    number = true,
    boolean = true,
    table = true,
    ["function"] = true,
    thread = true,
    userdata = true,
    ["nil"] = true,
    any = true,
    void = true,
    integer = true,
    unknown = true,
  }
  if std_types[module] then
    return false
  end
  local path = script_dir .. "/../docs/src/" .. module
  return exists_dir(path)
end

local function is_api_page(module, stem)
  -- 1. Check if the generated markdown file exists in the central docs repo
  local central_path = string.format("%s/../docs/src/%s/api/%s.md", script_dir, module, stem)
  local f = io.open(central_path, "r")
  if f then
    f:close()
    return true
  end

  -- 2. Check if the source type file exists in the current types directory
  if types_dir then
    local t1 = io.open(string.format("%s/%s.lua", types_dir, stem), "r")
    if t1 then
      t1:close()
      return true
    end
    local t2 = io.open(string.format("%s/%s.d.lua", types_dir, stem), "r")
    if t2 then
      t2:close()
      return true
    end
  end

  -- 3. Check if it exists in the output directory
  if output_dir then
    local out_path = io.open(string.format("%s/%s.md", output_dir, stem), "r")
    if out_path then
      out_path:close()
      return true
    end
  end

  return false
end

-- =========================================================================
-- Common Helper Functions
-- =========================================================================

local function trim(s)
  return s and s:match("^%s*(.-)%s*$") or ""
end

local function split_name_rest(s)
  if type(s) ~= "string" then
    return
  end

  s = s:gsub("^%s+", "")
  if s == "" then
    return
  end

  local depth = 0
  local quote = nil
  local escape = false

  for i = 1, #s do
    local ch = s:sub(i, i)
    if quote then
      if escape then
        escape = false
      elseif ch == "\\" then
        escape = true
      elseif ch == quote then
        quote = nil
      end
    else
      if ch == '"' or ch == "'" then
        quote = ch
      elseif ch == "(" or ch == "[" or ch == "{" or ch == "<" then
        depth = depth + 1
      elseif ch == ")" or ch == "]" or ch == "}" or ch == ">" then
        if depth > 0 then
          depth = depth - 1
        end
      elseif ch:match("%s") and depth == 0 then
        local name = s:sub(1, i - 1)
        local rest = s:sub(i + 1)
        return name, rest:gsub("^%s+", "")
      end
    end
  end

  return s, ""
end

local function split_type_desc_from_view(view)
  view = trim(view)
  if view:match("^fun%(") then
    local depth = 0
    local params_end = nil
    for i = 1, #view do
      local ch = view:sub(i, i)
      if ch == "(" then
        depth = depth + 1
      elseif ch == ")" then
        depth = depth - 1
        if depth == 0 then
          params_end = i
          break
        end
      end
    end

    if params_end then
      local after = view:sub(params_end + 1)
      local start_idx, end_idx = after:find("^%s*:%s*")
      if start_idx then
        local ret_part = after:sub(end_idx + 1)
        local ret_part_trimmed = trim(ret_part)
        if ret_part_trimmed:sub(1, 1) == "(" then
          local r_depth = 0
          local r_end = nil
          for i = 1, #ret_part do
            local ch = ret_part:sub(i, i)
            if ch == "(" then
              r_depth = r_depth + 1
            elseif ch == ")" then
              r_depth = r_depth - 1
              if r_depth == 0 then
                r_end = i
                break
              end
            end
          end
          if r_end then
            local tp = view:sub(1, params_end + end_idx + r_end)
            local desc = trim(ret_part:sub(r_end + 1))
            return tp, desc
          end
        else
          local ret_type, desc = ret_part_trimmed:match("^(%S+)%s*(.*)$")
          if ret_type then
            local tp = view:sub(1, params_end) .. after:sub(1, end_idx) .. ret_type
            return tp, trim(desc)
          end
        end
      else
        local desc = trim(after)
        return view:sub(1, params_end), desc
      end
    end
  end

  return split_name_rest(view)
end

local function esc_table_cell(s)
  return (s or ""):gsub("\n", " "):gsub("|", "\\|")
end

local function resolve_internal_links(s)
  if type(s) ~= "string" then
    return s
  end
  return s:gsub(internal_link_pattern, function(path)
    local base, hash = path:match("^([^#]+)(#.+)$")
    base = base or path
    hash = hash or ""
    base = base:gsub("%.html$", ""):gsub("%.md$", "")
    return "/" .. base .. hash
  end)
end

local function is_function_doc_item(item)
  if not item or item.kind ~= "alias" then
    return false
  end
  if type(item.name) ~= "string" or not item.name:match("^M%.[%a_][%w_]*$") then
    return false
  end
  if type(item.alias_of) == "string" and item.alias_of:match("^M%.[%a_][%w_]*$") then
    if item.name:lower() == item.alias_of:lower() then
      return false
    end
  end
  return true
end

local function clean_main_content(s)
  local split_idx = s:find("<!-- prettier-ignore-start -->", 1, true)
  local main_content
  if split_idx then
    main_content = s:sub(1, split_idx - 1)
  else
    main_content = s
  end
  -- Strip all trailing newlines and whitespace
  main_content = main_content:gsub("%s*$", "")
  return main_content
end

local function convert_inline_links_to_references(s)
  if type(s) ~= "string" then
    return s
  end

  local main_content = clean_main_content(s)

  -- Extract existing references from s (if any)
  local existing_refs = {}
  local split_idx = s:find("<!-- prettier-ignore-start -->", 1, true)
  if split_idx then
    local ref_block = s:sub(split_idx)
    for line in ref_block:gmatch("[^\r\n]+") do
      local key, url = line:match("^%s*%[([^%]]+)%]%:%s*(%S+)%s*$")
      if key and url then
        existing_refs[key] = url
      end
    end
  end

  local new_refs = {}

  -- Match [link text](url) (skipping lines that start with a markdown header prefix '#')
  local lines = {}
  for line in (main_content .. "\n"):gmatch("([^\n]*)\n") do
    if line:match("^%s*#") then
      insert(lines, line)
    else
      local modified_line = line:gsub("([%!]?)%[([^%]]+)%]%(([^%)]+)%)", function(is_image, text, url)
        if is_image == "!" then
          return "!" .. "[" .. text .. "](" .. url .. ")"
        end

        local clean_text = text:gsub("^%s*(.-)%s*$", "%1")
        local key = clean_text
        local target_key = nil

        if (existing_refs[key] and existing_refs[key] == url) or (new_refs[key] and new_refs[key] == url) then
          target_key = key
        elseif not existing_refs[key] and not new_refs[key] then
          new_refs[key] = url
          target_key = key
        else
          local base_key = key
          local is_code = base_key:match("^`([^`]+)`$")
          local i = 1
          while true do
            local candidate
            if is_code then
              candidate = "`" .. is_code .. "-" .. i .. "`"
            else
              candidate = base_key .. "-" .. i
            end

            if
              (existing_refs[candidate] and existing_refs[candidate] == url)
              or (new_refs[candidate] and new_refs[candidate] == url)
            then
              target_key = candidate
              break
            elseif not existing_refs[candidate] and not new_refs[candidate] then
              new_refs[candidate] = url
              target_key = candidate
              break
            end
            i = i + 1
          end
        end

        if clean_text == target_key then
          return "[" .. clean_text .. "]"
        else
          return "[" .. clean_text .. "][" .. target_key .. "]"
        end
      end)
      insert(lines, modified_line)
    end
  end
  local modified_content = concat(lines, "\n")

  for k, v in pairs(new_refs) do
    existing_refs[k] = v
  end

  local sorted_keys = {}
  for k in pairs(existing_refs) do
    local escaped = k:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
    local pattern = "%[%s*" .. escaped .. "%s*%]"
    if modified_content:find(pattern) then
      insert(sorted_keys, k)
    end
  end
  sort(sorted_keys)

  if #sorted_keys == 0 then
    return modified_content .. "\n"
  end

  local new_ref_lines = {}
  for _, k in ipairs(sorted_keys) do
    insert(new_ref_lines, string.format("[%s]: %s", k, existing_refs[k]))
  end

  local new_ref_block_content = concat(new_ref_lines, "\n")

  return modified_content
    .. "\n\n<!-- prettier-ignore-start -->\n"
    .. new_ref_block_content
    .. "\n<!-- prettier-ignore-end -->\n"
end

local function resolve_code_spans_and_add_links(s)
  if type(s) ~= "string" then
    return s
  end

  local main_content = clean_main_content(s)

  -- Extract existing references from s (if any)
  local existing_refs = {}
  local split_idx = s:find("<!-- prettier-ignore-start -->", 1, true)
  if split_idx then
    local ref_block = s:sub(split_idx)
    for name, url in ref_block:gmatch("%[?`([^`]+)`%]?:%s*(%S+)") do
      existing_refs[name] = url
    end
  end

  -- Extract code blocks to prevent backtick parity shifting
  local code_blocks = {}
  local block_count = 0
  local cursor = 1
  local parts = {}
  while true do
    local start_idx, end_idx = main_content:find("```", cursor)
    if not start_idx then
      table.insert(parts, main_content:sub(cursor))
      break
    end
    local close_start, close_end = main_content:find("```", end_idx + 1)
    if not close_start then
      table.insert(parts, main_content:sub(cursor))
      break
    end
    local block = main_content:sub(start_idx, close_end)
    block_count = block_count + 1
    code_blocks[block_count] = block
    table.insert(parts, main_content:sub(cursor, start_idx - 1))
    table.insert(parts, string.format("\001CODEBLOCK%d\002", block_count))
    cursor = close_end + 1
  end
  main_content = table.concat(parts)

  local new_refs = {}
  local modified_content = main_content:gsub("([%[%w_]?)`([^`]+)`([%]%w_]?)", function(before, content, after)
    if before == "[" or after == "]" then
      return before .. "`" .. content .. "`" .. after
    end

    local module, rest = content:match("^([%w_]+)%.(.+)$")
    if module and is_valid_module(module) then
      local name_path, paren_part = rest:match("^([%w_%.:]+)(.*)$")
      if name_path then
        local clean_p = module .. "." .. name_path
        local first_seg = name_path:match("^([^%.%:]+)") or name_path
        local stem = first_seg:lower()
        local url
        if is_api_page(module, stem) then
          url = string.format("/%s/api/%s", module, stem)
          local remaining = name_path:sub(#first_seg + 2)
          if remaining ~= "" then
            local anchor = remaining:lower():gsub("[^%w%-]+", "-"):gsub("%-+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
            url = url .. "#" .. anchor
          end
        else
          local slug = clean_p:lower():gsub("[^%w%-]+", "-"):gsub("%-+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
          url = string.format("/%s/types#%s", module, slug)
        end

        local display_text = module .. "." .. name_path .. paren_part
        new_refs[display_text] = url
        return before .. "[`" .. display_text .. "`]" .. after
      end
    end

    return before .. "`" .. content .. "`" .. after
  end)

  -- Restore code blocks
  for i = 1, block_count do
    modified_content = modified_content:gsub("\001CODEBLOCK" .. i .. "\002", function()
      return code_blocks[i]
    end)
  end

  for name, url in pairs(new_refs) do
    existing_refs[name] = url
  end

  local sorted_names = {}
  for name in pairs(existing_refs) do
    table.insert(sorted_names, name)
  end
  table.sort(sorted_names)

  if #sorted_names == 0 then
    return modified_content .. "\n"
  end

  local new_ref_lines = {}
  for _, name in ipairs(sorted_names) do
    table.insert(new_ref_lines, string.format("[`%s`]: %s", name, existing_refs[name]))
  end

  local new_ref_block_content = table.concat(new_ref_lines, "\n")

  return modified_content
    .. "\n\n<!-- prettier-ignore-start -->\n"
    .. new_ref_block_content
    .. "\n<!-- prettier-ignore-end -->\n"
end

local function sanitize_alias_part(part)
  local p = trim(part)
  local dq, dq_rest = p:match('^("[^"]*")%s*(.*)$')
  if dq then
    return dq, trim(dq_rest or "")
  end
  local sq, sq_rest = p:match([[^('[^']*')%s*(.*)$]])
  if sq then
    return '"' .. sq:sub(2, -2) .. '"', trim(sq_rest or "")
  end
  local val, desc = p:match("^([%w_%.:]+)%s+(.+)$")
  if val then
    return val, trim(desc or "")
  end
  return p, ""
end

local function alias_view_to_string(view)
  if type(view) == "table" then
    local out = {}
    local alias_desc = nil
    for _, part in ipairs(view) do
      local p, extra = sanitize_alias_part(tostring(part))
      if p ~= "" then
        insert(out, p)
      end
      if extra ~= "" and not alias_desc then
        alias_desc = extra
      end
    end
    return table.concat(out, " | "), alias_desc
  end
  return trim(tostring(view or "")), nil
end

local function is_literal(val)
  local s = tostring(val)
  if s:match("^['\"]") then
    return true
  end
  if tonumber(s) then
    return true
  end
  if s == "true" or s == "false" then
    return true
  end
  return false
end

local function compare_union_values(a, b)
  local val_a = a.value
  local val_b = b.value

  local lit_a = is_literal(val_a)
  local lit_b = is_literal(val_b)

  if lit_a ~= lit_b then
    return lit_a
  end

  local num_a = tonumber(val_a)
  local num_b = tonumber(val_b)
  if num_a and num_b then
    return num_a < num_b
  end

  local str_a = tostring(val_a):gsub("^['\"]", ""):gsub("['\"]$", ""):lower()
  local str_b = tostring(val_b):gsub("^['\"]", ""):gsub("['\"]$", ""):lower()
  return str_a < str_b
end

local function get_union_parts(view)
  if type(view) == "table" then
    local parts = {}
    for _, part in ipairs(view) do
      local p, extra = sanitize_alias_part(tostring(part))
      if p ~= "" then
        insert(parts, { value = p, desc = extra ~= "" and extra or nil })
      end
    end
    return parts
  end
  return nil
end

local function get_table_fields(val_str)
  local s = trim(val_str)
  if s:sub(1, 1) == "{" and s:sub(-1, -1) == "}" then
    local fields_str = s:sub(2, -2)
    local fields = {}
    for part in fields_str:gmatch("[^,]+") do
      local k, t = part:match("^%s*([%w_%?]+)%s*:%s*(.*)$")
      if k and t then
        insert(fields, { key = trim(k), type = trim(t) })
      end
    end
    if #fields > 0 then
      return fields
    end
  end
  return nil
end

-- =========================================================================
-- File System / CLI Helpers
-- =========================================================================

local function mkdir_p(path)
  if has_ffi then
    local current = ""
    if path:sub(1, 1) == "/" then
      current = "/"
    end
    for part in path:gmatch("[^/]+") do
      if current == "/" or current == "" then
        current = current .. part
      else
        current = current .. "/" .. part
      end
      ffi.C.mkdir(current, 493) -- 0755 permissions
    end
  else
    os.execute("mkdir -p " .. shell_quote(path))
  end
end

local function read_file(path)
  local f = assert(io.open(path, "rb"))
  local data = f:read("*a")
  f:close()
  return data
end

local function write_file(path, data)
  local f = assert(io.open(path, "wb"))
  f:write(data)
  f:close()
end

local function list_type_files(path, include_all)
  local p = assert(io.popen("ls -1 " .. shell_quote(path), "r"))
  local out = {}
  for line in p:lines() do
    if line:match("%.lua$") then
      if include_all or line:sub(1, 1) ~= "_" then
        insert(out, line)
      end
    end
  end
  p:close()
  sort(out)
  return out
end

-- =========================================================================
-- API Markdown Renderer
-- =========================================================================

local function first_match(items, pred)
  for _, item in ipairs(items or {}) do
    if pred(item) then
      return item
    end
  end
end

local function pick_module_name(items, stem)
  local item = first_match(items, function(it)
    return it.kind == "meta" and it.shortname
  end)
  local name = item and item.shortname or "module"
  if name == "_" and stem then
    return stem
  end
  return name
end

local function pick_module_desc(items, module_name)
  local meta_item = first_match(items, function(it)
    return it.kind == "meta" and it.desc
  end)
  if meta_item then
    return meta_item.desc
  end

  local m_class = first_match(items, function(it)
    if it.kind ~= "class" or not it.desc then
      return false
    end
    if it.var_name == "M" then
      return true
    end
    local view_name = it.view:match("^([^:]+)") or it.view
    view_name = trim(view_name):gsub("<[^>]+>", "")
    return view_name == "M"
  end)
  if m_class then
    return m_class.desc
  end

  local class_item = first_match(items, function(it)
    return it.kind == "class" and it.desc
  end)
  if class_item then
    return class_item.desc
  end

  local item_with_desc = first_match(items, function(it)
    return it.desc
  end)
  return item_with_desc and item_with_desc.desc
end

local function has_function_items(items)
  return first_match(items, function(it)
    return it.kind == "function" or is_function_doc_item(it)
  end) ~= nil
end

local function collect_include_paths(items)
  local out = {}
  local seen = {}
  for _, item in ipairs(items or {}) do
    local tags = item and item.tags
    local includes = tags and tags.includes
    if type(includes) == "table" then
      for _, path in ipairs(includes) do
        if type(path) == "string" and path ~= "" and not seen[path] then
          seen[path] = true
          insert(out, path)
        end
      end
    end
  end
  return out
end

local function collect_include_blocks(items)
  local out = {}
  for _, item in ipairs(items or {}) do
    local tags = item and item.tags
    local blocks = tags and tags.include_blocks
    if type(blocks) == "table" then
      for _, block in ipairs(blocks) do
        if type(block) == "string" and block ~= "" then
          insert(out, block)
        end
      end
    end
  end
  return out
end

local function count_function_items(items)
  local n = 0
  for _, item in ipairs(items or {}) do
    if item and (item.kind == "function" or is_function_doc_item(item)) then
      n = n + 1
    end
  end
  return n
end

local function collect_class_fields(items)
  local out = {}
  local seen = {}
  for _, item in ipairs(items or {}) do
    if item and item.kind == "class" then
      local tags = item.tags
      local fields = tags and tags.fields
      if type(fields) == "table" then
        for _, field in ipairs(fields) do
          local name = field and field.name
          local desc = (field and field.desc or ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
          if name and name ~= "__index" and (desc ~= "" or field.value ~= nil) and not seen[name] then
            seen[name] = true
            insert(out, field)
          end
        end
      end
    end
  end
  sort(out, function(a, b)
    return (a.name or "") < (b.name or "")
  end)
  return out
end

local function value_to_markdown(value)
  local t = type(value)
  if t == "string" then
    return fmt("`%q`", value)
  elseif t == "number" or t == "boolean" then
    return fmt("`%s`", tostring(value))
  end
end

local function first_sentence(s)
  if not s then
    return nil
  end
  local flattened = s:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  if flattened == "" then
    return nil
  end
  local period = flattened:find("%.")
  if period then
    return flattened:sub(1, period)
  end
  return flattened
end

local function render_frontmatter(module_name, desc)
  local lines = { "---" }
  insert(lines, fmt('title: "%s"', module_name:gsub('"', '\\"')))
  local short_desc = first_sentence(desc)
  if short_desc then
    local clean_desc = short_desc:gsub("<[^>]+>", "")
    insert(lines, fmt('description: "%s"', clean_desc:gsub('"', '\\"')))
  end
  insert(lines, "---")
  return concat(lines, "\n")
end

local function first_paragraph(s)
  if not s then
    return ""
  end
  local para = s:match("^(.-)\n%s*\n") or s
  return para:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function heading_anchor(s)
  return (s or ""):lower():gsub("_+", "-"):gsub("[^%w-]+", ""):gsub("^%-+", ""):gsub("%-+$", "")
end

local function function_signature(item)
  local base = item.shortname or item.name or ""
  if item.kind == "alias" then
    return base
  end
  local params = {}
  local tag_params = item.tags and item.tags.params
  if type(tag_params) == "table" then
    for _, param in ipairs(tag_params) do
      local name = param and param.name
      if name and name ~= "" and name ~= "self" then
        insert(params, name)
      end
    end
  end
  if #params == 0 then
    return base .. "()"
  end
  return base .. "(" .. concat(params, ", ") .. ")"
end

local function function_ref_id(item)
  return heading_anchor(item.shortname or item.name or "")
end

local function format_type_value_ref(val)
  local s = tostring(val):gsub("self:%s*[^,)]+", "self")
  s = s:gsub("([%w_]+)%s*:%s*([^,%)]-)%?", "%1?: %2")
  local parts = {}
  for part in s:gmatch("[^|]+") do
    local p = part:match("^%s*(.-)%s*$") -- trim
    local formatted = p:gsub("([%w_]+)%.([%w_%.]+)", function(module, name)
      if module and is_valid_module(module) then
        local first_seg = name:match("^([^%.]+)") or name
        local stem = first_seg:lower()
        local url
        if is_api_page(module, name:lower()) then
          url = string.format("/%s/api/%s", module, name:lower())
        else
          local clean_p = module .. "." .. name
          local slug = clean_p:lower():gsub("[^%w%-]+", "-"):gsub("%-+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
          url = string.format("/%s/types#%s", module, slug)
        end
        local clean_p = module .. "." .. name
        link_refs[clean_p] = url
        return "`[`" .. clean_p .. "`]`"
      end
      return nil
    end)
    local final_part = ("`" .. formatted .. "`"):gsub("``", "")
    insert(parts, final_part)
  end
  return table.concat(parts, " | ")
end

local function collect_alias_views(items)
  local out = {}
  for _, item in ipairs(items or {}) do
    if item and item.kind == "alias" and item.view ~= nil then
      local expanded, alias_desc = alias_view_to_string(item.view)
      if expanded ~= "" then
        local data = { view = expanded, desc = alias_desc or item.desc }
        if type(item.name) == "string" and item.name ~= "" then
          out[item.name] = data
        end
        if type(item.shortname) == "string" and item.shortname ~= "" then
          out[item.shortname] = data
        end
      end
    end
  end
  return out
end

local function expand_type_view(view, alias_views, seen)
  local v = trim(tostring(view or ""))
  if v == "" then
    return "any", nil
  end
  local mapped = alias_views and alias_views[v]
  if not mapped then
    return v, nil
  end
  seen = seen or {}
  if seen[v] then
    return v, mapped.desc
  end
  seen[v] = true
  local out, nested_desc = expand_type_view(mapped.view, alias_views, seen)
  seen[v] = nil
  return out, mapped.desc or nested_desc
end

local function normalize_api_desc(desc)
  local d = trim(desc or "")
  d = d:gsub("^#%s*", "")
  return d
end

local function adjust_optional_name_type(name, view)
  local clean_name = name or ""
  local clean_view = view or "any"

  if clean_view:sub(-1) == "?" and not clean_view:match("^%s*fun%(") then
    clean_view = clean_view:sub(1, -2)
    if clean_name ~= "" and clean_name:sub(-1) ~= "?" then
      clean_name = clean_name .. "?"
    end
  end

  return clean_name, clean_view
end

local function append_function_api_contract(doc, item, alias_views)
  local tags = item.tags or {}
  local params = tags.params or {}
  local returns = tags.returns or {}
  local has_params = false

  for _, param in ipairs(params) do
    local pname = param and param.name or ""
    if pname ~= "" and pname ~= "self" then
      has_params = true
      break
    end
  end
  local has_returns = #returns > 0

  if not has_params and not has_returns then
    return
  end

  if has_params then
    insert(doc, "**Parameters**:")
    for _, param in ipairs(params) do
      local pname = param and param.name or ""
      local pview = param and param.view or "any"
      local _, alias_desc = expand_type_view(pview, alias_views)
      local pdesc = normalize_api_desc(param and param.desc or "")
      if pdesc == "" and alias_desc and alias_desc ~= "" then
        pdesc = normalize_api_desc(alias_desc)
      end
      if pname ~= "" and pname ~= "self" then
        local clean_pname, clean_pview = adjust_optional_name_type(pname, pview)
        if pdesc ~= "" then
          insert(doc, fmt("- `%s` (%s): %s", clean_pname, format_type_value_ref(clean_pview), pdesc))
        else
          insert(doc, fmt("- `%s` (%s)", clean_pname, format_type_value_ref(clean_pview)))
        end
      end
    end
  end

  if has_returns then
    insert(doc, "")
    insert(doc, "**Returns**:")
    for _, ret in ipairs(returns) do
      local rname = ret and ret.name or ""
      local rview = ret and ret.view or "any"
      local _, alias_desc = expand_type_view(rview, alias_views)
      local rdesc = normalize_api_desc(ret and ret.desc or "")
      if rdesc == "" and alias_desc and alias_desc ~= "" then
        rdesc = normalize_api_desc(alias_desc)
      end
      local clean_rname, clean_rview = adjust_optional_name_type(rname, rview)
      local label
      if clean_rname ~= "" then
        label = "`" .. clean_rname .. "`"
      else
        if rview:sub(-1) == "?" and not rview:match("^%s*fun%(") then
          label = "**value?**"
        else
          label = "**value**"
        end
      end
      if rdesc ~= "" then
        insert(doc, fmt("- %s (%s): %s", label, format_type_value_ref(clean_rview), rdesc))
      else
        insert(doc, fmt("- %s (%s)", label, format_type_value_ref(clean_rview)))
      end
    end
  end

  insert(doc, "")
end

local function append_function_signature_details(doc, item, alias_views)
  local desc = item.desc or ""
  local before, code, after = desc:match("^(.-)```lua[^\n]*\n(.-)\n```(.*)$")

  if code then
    local pre = trim(before or "")
    if pre ~= "" then
      insert(doc, pre)
      insert(doc, "")
    end
  else
    if desc ~= "" then
      insert(doc, desc)
    end
  end

  append_function_api_contract(doc, item, alias_views)

  if code then
    insert(doc, "**Example**:")
    insert(doc, "```lua")
    insert(doc, trim(code))
    insert(doc, "```")
    local post = trim(after or "")
    if post ~= "" then
      insert(doc, "")
      insert(doc, post)
    end
    insert(doc, "")
  end
end

local function append_quick_ref_table(doc, rows)
  if not rows or #rows == 0 then
    return
  end

  insert(doc, "Function | Description")
  insert(doc, "---- | ----")
  for _, row in ipairs(rows) do
    local label
    if row.anchor and row.anchor ~= "" then
      label = fmt("[`%s`](#%s)", esc_table_cell(row.signature), row.anchor)
    else
      label = fmt("`%s`", esc_table_cell(row.signature))
    end
    insert(doc, fmt("%s | %s", label, esc_table_cell(row.desc)))
  end
end

local function append_fields_table(doc, fields, alias_views)
  if not fields or #fields == 0 then
    return
  end

  insert(doc, "Field | Description")
  insert(doc, "---- | ----")
  for _, field in ipairs(fields) do
    local name = field.name or ""
    local anchor = field.ref_id or heading_anchor(name)
    local link = fmt("[`%s`](#%s)", esc_table_cell(name), anchor)
    local fview = field and field.view or "any"
    local _, alias_desc = expand_type_view(fview, alias_views)
    local desc = esc_table_cell(first_paragraph(field.desc))
    if desc == "" and alias_desc and alias_desc ~= "" then
      desc = esc_table_cell(first_paragraph(alias_desc))
    elseif desc == "" and field.value ~= nil then
      desc = value_to_markdown(field.value) or ""
    end
    insert(doc, fmt("%s | %s", link, desc))
  end
end

local function sort_function_entries(entries)
  sort(entries, function(a, b)
    local a_name = a.item and (a.item.shortname or a.item.name)
    local b_name = b.item and (b.item.shortname or b.item.name)
    local a_is_new = a_name == "new"
    local b_is_new = b_name == "new"
    if a_is_new ~= b_is_new then
      return a_is_new
    end
    return (a.signature or "") < (b.signature or "")
  end)
end

local function sort_section_names(section_names)
  sort(section_names, function(a, b)
    local a_is_metamethods = a == "Metamethods"
    local b_is_metamethods = b == "Metamethods"
    if a_is_metamethods ~= b_is_metamethods then
      return not a_is_metamethods
    end
    local al = (a or ""):lower()
    local bl = (b or ""):lower()
    if al == bl then
      return (a or "") < (b or "")
    end
    return al < bl
  end)
end

local function has_section_field(items)
  for _, item in ipairs(items or {}) do
    local tags = item and item.tags
    local section = tags and tags.section
    if section and section.view and section.view ~= "" then
      return true
    end
    if item.kind == "function" or is_function_doc_item(item) then
      local name = item.shortname or item.name or ""
      if name:sub(1, 2) == "__" then
        return true
      end
    end
  end
  return false
end

local function render_api_markdown(items, filename)
  link_refs = {}
  local seen_anchors = {}
  local function unique_anchor(anchor)
    if not seen_anchors[anchor] then
      seen_anchors[anchor] = true
      return anchor
    end
    local i = 1
    while true do
      local candidate = anchor .. "-" .. i
      if not seen_anchors[candidate] then
        seen_anchors[candidate] = true
        return candidate
      end
      i = i + 1
    end
  end

  local stem = filename and page_stem(filename)
  local module_name = pick_module_name(items, stem)
  local module_desc = pick_module_desc(items, module_name)
  local fields = collect_class_fields(items)
  for _, field in ipairs(fields) do
    field.ref_id = unique_anchor(heading_anchor(field.name or ""))
  end
  local has_functions = has_function_items(items)
  local total_functions = count_function_items(items)
  local has_functions_header = has_functions and total_functions > 1
  local include_paths = collect_include_paths(items)
  local include_blocks = collect_include_blocks(items)
  local frontmatter = render_frontmatter(module_name, module_desc)
  local section_fields = has_section_field(items)
  local alias_views = collect_alias_views(items)
  local function_heading_level
  local unsectioned_function_heading_level
  if section_fields then
    function_heading_level = "####"
    unsectioned_function_heading_level = "###"
  elseif has_functions_header then
    function_heading_level = "###"
    unsectioned_function_heading_level = "###"
  else
    function_heading_level = "##"
    unsectioned_function_heading_level = "##"
  end
  local quick_ref = {}
  local section_order = {}
  local seen_sections = {}
  local function_count = 0
  local detail_entries = {}
  local detail_sections = {}
  local doc = {}
  if frontmatter then
    insert(doc, frontmatter)
  end
  if module_desc then
    insert(doc, module_desc)
  end

  if not has_functions and #fields == 0 then
    for _, path in ipairs(include_paths) do
      local content = read_file(path)
      if content and content ~= "" then
        insert(doc, content)
      end
    end
    for _, block in ipairs(include_blocks) do
      insert(doc, block)
    end
    local output = concat(doc, "\n")
    output = resolve_code_spans_and_add_links(output)
    output = resolve_internal_links(output)
    return convert_inline_links_to_references(output)
  end

  if #fields > 0 then
    insert(doc, "## Fields")
    if #fields >= FIELD_OVERVIEW_MIN then
      append_fields_table(doc, fields, alias_views)
    end
    insert(doc, "")
    local first_field = true
    for _, field in ipairs(fields) do
      if not first_field then
        insert(doc, "---")
        insert(doc, "")
      end
      first_field = false
      local ref_id = field.ref_id or heading_anchor(field.name or "")
      local fview = field and field.view
      local heading
      if fview and fview ~= "" then
        local _, alias_desc = expand_type_view(fview, alias_views)
        heading = fmt("### `%s` (%s) {#%s}", field.name or "", format_type_value_ref(fview), ref_id)
        insert(doc, heading)
        if (not field.desc or field.desc == "") and alias_desc and alias_desc ~= "" then
          insert(doc, "")
          insert(doc, alias_desc)
        end
      else
        heading = fmt("### `%s` {#%s}", field.name or "", ref_id)
        insert(doc, heading)
      end
      if field.desc then
        insert(doc, "")
        insert(doc, field.desc)
      elseif field.value ~= nil then
        local rendered_value = value_to_markdown(field.value)
        if rendered_value then
          insert(doc, "")
          insert(doc, "Value: " .. rendered_value)
        end
      end
    end
    insert(doc, "")
  end

  if has_functions_header then
    insert(doc, "## Functions")
  end

  for _, item in ipairs(items) do
    if has_functions and (item.kind == "function" or is_function_doc_item(item)) then
      local alias_doc_item = is_function_doc_item(item)
      function_count = function_count + 1
      local signature = function_signature(item)
      local ref_id = unique_anchor(function_ref_id(item))
      local tags = item.tags or {}
      local section_tag = tags.section
      local section_name = nil
      if section_tag and section_tag.view and section_tag.view ~= "" then
        section_name = section_tag.view
      end
      local item_name = item.shortname or item.name or ""
      if item_name:sub(1, 2) == "__" then
        section_name = "Metamethods"
      end
      local row_anchor = ref_id
      if alias_doc_item then
        row_anchor = nil
      end
      local row = {
        signature = signature,
        anchor = row_anchor,
        desc = first_paragraph(item.desc),
      }
      if section_fields then
        local entry = {
          signature = signature,
          row = row,
          item = alias_doc_item and nil or item,
          ref_id = ref_id,
        }
        if section_name then
          if not detail_sections[section_name] then
            detail_sections[section_name] = {
              heading = fmt("### %s", section_name),
              entries = {},
            }
          end
          if not seen_sections[section_name] then
            insert(section_order, section_name)
            seen_sections[section_name] = true
          end
          insert(detail_sections[section_name].entries, entry)
        else
          insert(detail_entries, entry)
        end
      else
        insert(detail_entries, {
          signature = signature,
          row = row,
          item = alias_doc_item and nil or item,
          ref_id = ref_id,
        })
      end
    end
  end

  -- Show quick reference only for larger modules.
  if has_functions and function_count > 3 then
    if section_fields then
      sort_section_names(section_order)
      if #detail_entries > 0 then
        sort_function_entries(detail_entries)
        for _, entry in ipairs(detail_entries) do
          insert(quick_ref, entry.row)
        end
        append_quick_ref_table(doc, quick_ref)
      end
      for _, section_name in ipairs(section_order) do
        local section = detail_sections[section_name]
        local rows = {}
        if section and #section.entries > 0 then
          sort_function_entries(section.entries)
          for _, entry in ipairs(section.entries) do
            insert(rows, entry.row)
          end
          insert(doc, fmt("\n**%s**:\n", section_name))
          append_quick_ref_table(doc, rows)
        end
      end
    else
      sort_function_entries(detail_entries)
      for _, entry in ipairs(detail_entries) do
        insert(quick_ref, entry.row)
      end
      append_quick_ref_table(doc, quick_ref)
    end
  end

  if section_fields then
    sort_section_names(section_order)
    sort_function_entries(detail_entries)
    local first = true
    for _, entry in ipairs(detail_entries) do
      if entry.item then
        if not first then
          insert(doc, "---")
          insert(doc, "")
        end
        first = false
        insert(doc, fmt("%s `%s` {#%s}", unsectioned_function_heading_level, entry.signature, entry.ref_id))
        append_function_signature_details(doc, entry.item, alias_views)
      end
    end
    for _, section_name in ipairs(section_order) do
      local section = detail_sections[section_name]
      if section then
        if not first then
          insert(doc, "---")
          insert(doc, "")
        end
        insert(doc, section.heading)
        if section.desc then
          insert(doc, section.desc)
        end
        sort_function_entries(section.entries)
        local first_sec = true
        for _, entry in ipairs(section.entries) do
          if entry.item then
            if not first_sec then
              insert(doc, "---")
              insert(doc, "")
            end
            first_sec = false
            first = false
            insert(doc, fmt("%s `%s` {#%s}", function_heading_level, entry.signature, entry.ref_id))
            append_function_signature_details(doc, entry.item, alias_views)
          end
        end
      end
    end
  else
    sort_function_entries(detail_entries)
    local first = true
    for _, entry in ipairs(detail_entries) do
      if entry.item then
        if not first then
          insert(doc, "---")
          insert(doc, "")
        end
        first = false
        insert(doc, fmt("%s `%s` {#%s}", function_heading_level, entry.signature, entry.ref_id))
        append_function_signature_details(doc, entry.item, alias_views)
      end
    end
  end

  for _, path in ipairs(include_paths) do
    local content = read_file(path)
    if content and content ~= "" then
      insert(doc, content)
    end
  end

  for _, block in ipairs(include_blocks) do
    insert(doc, block)
  end

  local sorted_refs = {}
  for name, url in pairs(link_refs) do
    insert(sorted_refs, string.format("[`%s`]: %s", name, url))
  end
  if #sorted_refs > 0 then
    sort(sorted_refs)
    insert(doc, "")
    insert(doc, "<!-- prettier-ignore-start -->")
    insert(doc, concat(sorted_refs, "\n"))
    insert(doc, "<!-- prettier-ignore-end -->")
  end

  local output = concat(doc, "\n")
  output = resolve_code_spans_and_add_links(output)
  output = resolve_internal_links(output)
  return convert_inline_links_to_references(output)
end

-- =========================================================================
-- Consolidated Types/Alias Generation
-- =========================================================================

local function split_top_level_unions(s)
  local parts = {}
  local current = {}
  local depth = 0
  for i = 1, #s do
    local char = s:sub(i, i)
    if char == "(" or char == "{" or char == "<" then
      depth = depth + 1
      insert(current, char)
    elseif char == ")" or char == "}" or char == ">" then
      if depth > 0 then
        depth = depth - 1
      end
      insert(current, char)
    elseif char == "|" and depth == 0 then
      insert(parts, table.concat(current))
      current = {}
    else
      insert(current, char)
    end
  end
  if #current > 0 then
    insert(parts, table.concat(current))
  end
  return parts
end

local function format_type_value_inline(val)
  local s = tostring(val):gsub("self:%s*[^,)]+", "self")
  local raw_parts = split_top_level_unions(s)
  local parts = {}
  for _, part in ipairs(raw_parts) do
    local p = part:match("^%s*(.-)%s*$") -- trim
    if p ~= "" then
      local has_link = false
      local formatted = p:gsub("([%w_]+)%.([%w_%.]+)", function(module, name)
        if module and is_valid_module(module) then
          has_link = true
          local first_seg = name:match("^([^%.]+)") or name
          local url
          if is_api_page(module, name:lower()) then
            url = string.format("/%s/api/%s", module, name:lower())
          else
            local clean_p = module .. "." .. name
            local slug = clean_p:lower():gsub("[^%w%-]+", "-"):gsub("%-+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
            url = string.format("/%s/types#%s", module, slug)
          end
          return '<a href="' .. url .. '">' .. module .. "." .. name .. "</a>"
        end
        return nil
      end)
      local final_part
      if has_link then
        final_part = "<code>" .. formatted .. "</code>"
      else
        final_part = "`" .. formatted .. "`"
      end
      insert(parts, final_part)
    end
  end
  return table.concat(parts, " | ")
end

local function format_function_type(fn)
  local params = {}
  if fn.tags and fn.tags.params then
    for _, p in ipairs(fn.tags.params) do
      if p.name and p.name ~= "self" then
        local cname, cview = adjust_optional_name_type(p.name, p.view)
        if cname:sub(-1) == "?" then
          insert(params, cname:sub(1, -2) .. "?: " .. cview)
        else
          insert(params, cname .. ": " .. cview)
        end
      end
    end
  end
  local rets = {}
  if fn.tags and fn.tags.returns then
    for _, r in ipairs(fn.tags.returns) do
      if r.view then
        insert(rets, r.view)
      end
    end
  end
  local ret_str = #rets > 0 and (": " .. table.concat(rets, "|")) or ""
  return "fun(" .. table.concat(params, ", ") .. ")" .. ret_str
end

local function generate_alias_docs(types_dir, output_dir)
  if not exists_dir(types_dir) then
    error("types directory does not exist: " .. types_dir)
  end

  local files = list_type_files(types_dir, true)
  if #files == 0 then
    error("no Lua type files found in: " .. types_dir)
  end

  mkdir_p(output_dir)

  local aliases = {}
  local classes = {}
  local all_functions = {}
  local function_prefixes = {}
  for _, filename in ipairs(files) do
    local content = read_file(types_dir .. "/" .. filename)
    local parsed = lls.parse(content)
    for _, item in ipairs(parsed or {}) do
      item.filename = filename
      if (item.kind == "alias" and not is_function_doc_item(item)) or item.kind == "enum" then
        local alias_name = (item.name or ""):gsub("<[^>]+>", "")
        if
          alias_name ~= ""
          and alias_name ~= "_"
          and alias_name ~= "M"
          and not alias_name:match("^M%.")
          and alias_name ~= "_G"
          and not alias_name:match("^_G%.")
        then
          insert(aliases, item)
        end
      elseif item.kind == "class" then
        local class_name = item.view:match("^([^:]+)") or item.view
        class_name = trim(class_name):gsub("<[^>]+>", "")
        if
          class_name ~= ""
          and class_name ~= "_"
          and class_name ~= "M"
          and not class_name:match("^M%.")
          and class_name ~= "_G"
          and not class_name:match("^_G%.")
        then
          insert(classes, item)
        end
      elseif item.kind == "function" or (item.kind == "alias" and is_function_doc_item(item)) then
        if item.name then
          local prefix = item.name:match("^(.+)[%.:]")
          if prefix then
            prefix = trim(prefix)
            function_prefixes[prefix:lower()] = true
          end
          insert(all_functions, item)
        end
      end
    end
  end

  local module_name = types_dir:match("([^/]+)$") or "module"
  for _, item in ipairs(aliases) do
    local prefix = (item.name or ""):match("^([%w_]+)%.")
    if prefix then
      module_name = prefix
      break
    end
  end
  if module_name == "module" then
    for _, item in ipairs(classes) do
      local prefix = (item.view or ""):match("^([%w_]+)%.")
      if prefix then
        module_name = prefix
        break
      end
    end
  end

  local function strip_generics(name)
    if not name then
      return nil
    end
    return name:gsub("<[^>]+>", "")
  end

  for _, item in ipairs(classes) do
    local class_name = item.view:match("^([^:]+)") or item.view
    class_name = trim(class_name)
    local clean_class_name = strip_generics(class_name) or ""
    local short_name = clean_class_name:match("[^%.]+$") or clean_class_name
    short_name = trim(short_name)

    local has_own_api_page = is_api_page(module_name, short_name:lower())

    local is_module_class = false
    if item.filename then
      local stem = item.filename:gsub("%.d%.lua$", ""):gsub("%.lua$", ""):lower()
      local stem_class_1 = (module_name .. "." .. stem):lower()
      local stem_class_2 = stem:lower()
      local cn_lower = clean_class_name:lower()
      if cn_lower == stem_class_1 or cn_lower == stem_class_2 then
        is_module_class = true
      end
    end

    if not has_own_api_page and not is_module_class then
      local mock_fields = {}
      local seen_keys = {}

      if item.tags and item.tags.fields then
        for _, f in ipairs(item.tags.fields) do
          if f.name then
            local tp = "any"
            local fdesc = nil
            if f.view then
              local extracted_tp, extracted_desc = split_type_desc_from_view(f.view)
              if extracted_tp then
                tp = extracted_tp
                if extracted_desc and extracted_desc ~= "" then
                  fdesc = trim(extracted_desc)
                end
              else
                tp = f.view
              end
            end
            if f.desc and trim(f.desc) ~= "" then
              fdesc = fdesc and (fdesc .. " " .. trim(f.desc)) or trim(f.desc)
            end
            insert(mock_fields, { key = f.name, type = tp, desc = fdesc })
            local clean_k = f.name:gsub("%?$", "")
            seen_keys[clean_k:lower()] = true
          end
        end
      end

      for _, fn in ipairs(all_functions) do
        if fn.name then
          local prefix = fn.name:match("^(.+)[%.:]")
          if prefix then
            prefix = trim(prefix):lower()
            if prefix == clean_class_name:lower() or prefix == short_name:lower() then
              local fn_key = fn.shortname or fn.name:match("[%.:]([^%.:]+)$") or fn.name
              local clean_key = fn_key:gsub("%?$", "")
              if not seen_keys[clean_key:lower()] then
                seen_keys[clean_key:lower()] = true
                local fn_type = format_function_type(fn)
                local fn_desc = nil
                if fn.desc and trim(fn.desc) ~= "" then
                  local para = first_paragraph(fn.desc)
                  if para ~= "" then
                    fn_desc = normalize_api_desc(para)
                  end
                end
                insert(mock_fields, { key = fn_key, type = fn_type, desc = fn_desc })
              end
            end
          end
        end
      end

      if #mock_fields > 0 then
        local mock_alias = {
          kind = "alias",
          name = class_name,
          view = class_name,
          desc = item.desc,
          fields = mock_fields,
          filename = item.filename,
          start = item.start,
          finish = item.finish,
        }
        insert(aliases, mock_alias)
      end
    end
  end

  if #aliases == 0 then
    return { output_dir = output_dir, files = 0 }
  end

  sort(aliases, function(a, b)
    return (a.name or ""):lower() < (b.name or ""):lower()
  end)

  local md = {}
  insert(md, "---")
  insert(md, 'title: "Types"')
  insert(md, 'description: "Types defined in the ' .. module_name .. ' module."')
  insert(md, 'pageClass: "types-page"')
  insert(md, "---")
  insert(md, "")
  insert(md, "Types defined in the " .. module_name .. " module.")

  local details = {}
  for _, item in ipairs(aliases) do
    local name = item.name or ""
    local val_str, val_desc = alias_view_to_string(item.view)
    local desc = trim(item.desc or "")

    local url =
      string.format(github_types_url_template, module_name, item.filename or "", item.start or 1, item.finish or 1)

    local detail = {}
    insert(detail, "## [`" .. name .. "`](" .. url .. ")")
    insert(detail, "")
    if desc ~= "" then
      insert(detail, desc)
      insert(detail, "")
    end

    if item.kind == "enum" then
      local is_map = false
      local keys = {}
      for k in pairs(item.values or {}) do
        if type(k) == "string" then
          is_map = true
        end
        insert(keys, k)
      end

      if is_map then
        sort(keys, function(a, b)
          return tostring(a):lower() < tostring(b):lower()
        end)
        local has_val_descs = false
        if item.value_descs then
          for _, k in ipairs(keys) do
            if item.value_descs[k] and item.value_descs[k] ~= "" then
              has_val_descs = true
              break
            end
          end
        end

        if has_val_descs then
          insert(detail, "Name | Value | Description")
          insert(detail, "--- | --- | ---")
          for _, k in ipairs(keys) do
            local val = item.values[k]
            local desc = item.value_descs[k] or ""
            insert(
              detail,
              string.format(
                "`%s` | %s | %s",
                k,
                value_to_markdown(val) or esc_table_cell(tostring(val)),
                esc_table_cell(desc)
              )
            )
          end
        else
          insert(detail, "Name | Value")
          insert(detail, "--- | ---")
          for _, k in ipairs(keys) do
            local val = item.values[k]
            insert(detail, string.format("`%s` | %s", k, value_to_markdown(val) or esc_table_cell(tostring(val))))
          end
        end
      else
        sort(keys, function(a, b)
          local val_a = item.values[a]
          local val_b = item.values[b]
          return tostring(val_a):lower() < tostring(val_b):lower()
        end)
        local inline = {}
        for _, k in ipairs(keys) do
          local val = item.values[k]
          insert(inline, value_to_markdown(val) or ("`" .. tostring(val) .. "`"))
        end
        insert(detail, "&nbsp;" .. table.concat(inline, " &nbsp;"))
      end
      insert(detail, "")
    else
      local parts = get_union_parts(item.view)
      if parts then
        sort(parts, compare_union_values)
        local has_any_desc = false
        for _, part in ipairs(parts) do
          if part.desc and part.desc ~= "" then
            has_any_desc = true
            break
          end
        end
        if has_any_desc then
          insert(detail, "Value | Description")
          insert(detail, "--- | ---")
          for _, part in ipairs(parts) do
            insert(
              detail,
              string.format(
                "%s | %s",
                esc_table_cell(format_type_value_inline(part.value)),
                esc_table_cell(part.desc or "")
              )
            )
          end
        else
          local inline = {}
          for _, part in ipairs(parts) do
            insert(inline, format_type_value_inline(part.value))
          end
          insert(detail, "&nbsp;" .. table.concat(inline, " &nbsp;"))
        end
        insert(detail, "")
      else
        local fields = item.fields or get_table_fields(val_str)
        if fields then
          local processed = {}
          for _, field in ipairs(fields) do
            local key = field.key
            local tp = field.type
            local desc = field.desc

            local is_opt = false
            if key:sub(-1) == "?" then
              key = key:sub(1, -2)
              is_opt = true
            elseif tp:sub(-1) == "?" then
              tp = tp:sub(1, -2)
              is_opt = true
            end

            local display_key = is_opt and (key .. "?") or key

            insert(processed, { key = key, display_key = display_key, type = tp, desc = desc })
          end

          sort(processed, function(a, b)
            return a.key:lower() < b.key:lower()
          end)

          local has_any_desc = false
          for _, f in ipairs(processed) do
            if f.desc and f.desc ~= "" then
              has_any_desc = true
              break
            end
          end

          if has_any_desc then
            insert(detail, "Key | Type | Description")
            insert(detail, "--- | --- | ---")
            for _, field in ipairs(processed) do
              insert(
                detail,
                string.format(
                  "`%s` | %s | %s",
                  field.display_key,
                  esc_table_cell(format_type_value_inline(field.type)),
                  esc_table_cell(field.desc or "")
                )
              )
            end
          else
            insert(detail, "Key | Type")
            insert(detail, "--- | ---")
            for _, field in ipairs(processed) do
              insert(
                detail,
                string.format("`%s` | %s", field.display_key, esc_table_cell(format_type_value_inline(field.type)))
              )
            end
          end
          insert(detail, "")
        else
          insert(detail, "`" .. val_str .. "`")
          insert(detail, "")
        end
      end
    end

    insert(details, table.concat(detail, "\n"))
  end

  insert(md, "")
  insert(md, table.concat(details, "\n\n"))

  local filepath = output_dir .. "/" .. types_file_name .. ".md"
  local output = table.concat(md, "\n")
  output = resolve_code_spans_and_add_links(output)
  output = resolve_internal_links(output)
  output = convert_inline_links_to_references(output)
  write_file(filepath, output)

  return { output_dir = output_dir, files = 1 }
end

-- =========================================================================
-- Main Driver Logic
-- =========================================================================

local function render_type_file(types_dir, filename)
  local content = read_file(types_dir .. "/" .. filename)
  return render_api_markdown(lls.parse(content), filename)
end

local function generate_docs(types_dir, output_dir)
  if not exists_dir(types_dir) then
    error("types directory does not exist: " .. types_dir)
  end

  local files = list_type_files(types_dir)
  if #files == 0 then
    error("no Lua type files found in: " .. types_dir)
  end

  mkdir_p(output_dir)

  local generated = 0
  for _, filename in ipairs(files) do
    local stem = page_stem(filename)
    if not ignored_stems[stem] then
      local markdown = render_type_file(types_dir, filename)
      write_file(output_dir .. "/" .. stem .. ".md", markdown)
      generated = generated + 1
    end
  end
  return { output_dir = output_dir, files = generated }
end

local function usage()
  return "usage: lua scripts/generate-docs.lua [types-dir] [output-dir]\n"
end

types_dir = (arg and arg[1]) or "types"
local input_output_dir = (arg and arg[2]) or "docs"
if types_dir == "-h" or types_dir == "--help" then
  io.stdout:write(usage())
  os.exit(0)
end

local base_dir
local clean_path = input_output_dir:gsub("[/\\]+$", "")
local escaped_api_name = api_dir_name:gsub("([^%w])", "%%%1")
local pattern = "([/\\])(" .. escaped_api_name .. ")$"
local _, suffix = clean_path:match(pattern)
if suffix then
  output_dir = clean_path
  base_dir = clean_path:sub(1, #clean_path - #suffix - 1)
else
  base_dir = clean_path
  output_dir = base_dir .. "/" .. api_dir_name
end

-- 1. Generate API docs in the specified output directory
local result = generate_docs(types_dir, output_dir)
io.stdout:write(string.format("generated %d doc file(s) in %s\n", result.files, result.output_dir))

-- 2. Generate consolidated alias types in the base directory
local alias_result = generate_alias_docs(types_dir, base_dir)
io.stdout:write(
  string.format("generated %d consolidated alias doc file(s) in %s\n", alias_result.files, alias_result.output_dir)
)

-- 3. Auto-format the generated markdown files using Prettier
os.execute("npx prettier --write " .. shell_quote(base_dir))
