local insert = table.insert
local concat = table.concat
local split_top_level_commas

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function rtrim(s)
  return (s:gsub("%s+$", ""))
end

local function is_blank(s)
  return trim(s) == ""
end

local function shortname(name)
  return name and (name:match("([%w_]+)$") or name) or nil
end

local function set_view(out, view)
  if view and view ~= "" then
    out.view = view
  end
  return out
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

local function normalize_desc(v)
  if type(v) ~= "string" then
    return nil
  end
  v = trim(v)
  if v == "" then
    return nil
  end
  return v
end

local function split_commas(s)
  local out = {}
  for part in s:gmatch("[^,]+") do
    local item = trim(part)
    if item ~= "" then
      insert(out, item)
    end
  end
  return out
end

local function join_desc(lines)
  if #lines == 0 then
    return
  end

  local out = {}
  local prev_blank = true
  for _, line in ipairs(lines) do
    if is_blank(line) then
      if not prev_blank then
        insert(out, "")
        prev_blank = true
      end
    else
      insert(out, rtrim(line))
      prev_blank = false
    end
  end

  while #out > 0 and is_blank(out[1]) do
    table.remove(out, 1)
  end
  while #out > 0 and is_blank(out[#out]) do
    out[#out] = nil
  end

  if #out == 0 then
    return
  end
  return concat(out, "\n")
end

local function parse_name_view_desc(payload)
  local name, rest = split_name_rest(payload)
  if not name then
    return
  end
  local view, desc = split_name_rest(rest)
  return set_view({
    name = name,
    desc = normalize_desc(desc),
  }, view)
end

local parse_param = parse_name_view_desc

local function split_type_rest(s)
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

  local function non_space_char(idx, dir)
    local cur = idx + dir
    while cur >= 1 and cur <= #s do
      local ch = s:sub(cur, cur)
      if not ch:match("%s") then
        return ch
      end
      cur = cur + dir
    end
    return nil
  end

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
        local before = non_space_char(i, -1)
        local after = non_space_char(i, 1)
        local is_allowed = (before == "|" or before == "," or before == ":") or
                           (after == "|" or after == "," or after == ":")
        if not is_allowed then
          local type_part = s:sub(1, i - 1)
          local rest_part = s:sub(i + 1)
          return type_part, rest_part:gsub("^%s+", "")
        end
      end
    end
  end

  return s, ""
end

local function parse_return(payload)
  local view, rest
  if payload:match("^%s*fun%(") then
    view, rest = split_type_rest(payload)
  else
    view, rest = split_name_rest(payload)
  end

  if not view then
    return
  end
  local name, desc = split_name_rest(rest)
  return set_view({
    name = name ~= "" and name or nil,
    desc = normalize_desc(desc),
  }, view)
end

local function split_union_view(view_value)
  if not view_value or view_value == "" then
    return
  end
  if not view_value:find("|", 1, true) then
    return view_value
  end
  local parts = {}
  for part in view_value:gmatch("[^|]+") do
    local item = trim(part)
    if item ~= "" then
      insert(parts, item)
    end
  end
  return parts
end

local function build_union_view(lines, start_i)
  if not lines or #lines == 0 then
    return
  end
  local raw = {}
  for i = start_i or 1, #lines do
    local t = trim(lines[i])
    if t:sub(1, 1) == "|" then
      t = trim(t:sub(2))
    end
    if t ~= "" then
      insert(raw, t)
    end
  end
  if #raw == 0 then
    return
  end
  return concat(raw, "|")
end

local function parse_alias_tag(payload, desc_extra)
  if payload and payload ~= "" then
    local name, view = split_name_rest(payload)
    if not name then
      return
    end
    local inline_view, inline_desc
    if view ~= "" then
      inline_view, inline_desc = split_name_rest(view)
    end
    local view_value = build_union_view(desc_extra) or inline_view
    return set_view({ name = name, desc = normalize_desc(inline_desc) }, split_union_view(view_value))
  end

  if not desc_extra or #desc_extra == 0 then
    return
  end

  local lines = {}
  for _, line in ipairs(desc_extra) do
    local t = trim(line)
    if t ~= "" then
      insert(lines, t)
    end
  end

  if #lines == 0 then
    return
  end

  local name = lines[1]
  if name:sub(1, 1) == "|" then
    return
  end
  return set_view({ name = name }, split_union_view(build_union_view(lines, 2)))
end

local function parse_overload(payload)
  local params_str, ret_str, desc = payload:match("^fun%((.*)%)%s*:%s*([^%s]+)%s*(.*)$")
  if not params_str then
    return
  end

  local params = {}
  if params_str ~= "" then
    for _, part in ipairs(split_top_level_commas(params_str)) do
      local item = trim(part)
      local name, view = item:match("^(%S+)%s*:%s*(.+)$")
      if name then
        insert(params, set_view({ name = name }, view))
      end
    end
  end

  return {
    params = params,
    returns = { { view = ret_str } },
    desc = normalize_desc(desc),
  }
end

split_top_level_commas = function(s)
  local parts = {}
  local start_idx = 1
  local depth = 0
  for i = 1, #s do
    local ch = s:sub(i, i)
    if ch == "(" or ch == "[" or ch == "{" or ch == "<" then
      depth = depth + 1
    elseif ch == ")" or ch == "]" or ch == "}" or ch == ">" then
      if depth > 0 then
        depth = depth - 1
      end
    elseif ch == "," and depth == 0 then
      local part = trim(s:sub(start_idx, i - 1))
      if part ~= "" then
        insert(parts, part)
      end
      start_idx = i + 1
    end
  end
  local tail = trim(s:sub(start_idx))
  if tail ~= "" then
    insert(parts, tail)
  end
  return parts
end

local function parse_named_view(item)
  local name, view = item:match("^(%S+)%s*:%s*(.+)$")
  if name and view then
    return set_view({ name = name }, view)
  end
  return { view = item }
end

local function parse_fun_signature(view)
  local params_str, ret_str = view:match("^fun%((.*)%)%s*:%s*(.+)$")
  if not params_str then
    return
  end

  local params = {}
  if params_str ~= "" then
    for _, part in ipairs(split_top_level_commas(params_str)) do
      local item = trim(part)
      local name, pview = item:match("^(%S+)%s*:%s*(.+)$")
      if name then
        insert(params, set_view({ name = name }, pview))
      end
    end
  end

  local returns_str = trim(ret_str)
  if returns_str:match("^%b()$") then
    returns_str = trim(returns_str:sub(2, -2))
  end
  local returns = {}
  for _, rview in ipairs(split_top_level_commas(returns_str)) do
    insert(returns, parse_named_view(rview))
  end
  if #returns == 0 then
    insert(returns, parse_named_view(trim(ret_str)))
  end
  return params, returns
end

local function parse_field(payload)
  local name, rest = split_name_rest(payload)
  if not name then
    return
  end

  rest = rest or ""
  local first_line, tail = rest:match("^(.-)\n(.+)$")
  local view = trim(first_line or rest or "")
  local out = {
    name = name,
    desc = normalize_desc(tail),
  }

  if view ~= "" then
    out.view = view
  end

  if not out.view then
    return out
  end

  local params, returns = parse_fun_signature(out.view)
  if params then
    out.params = params
    out.returns = returns
  end
  return out
end

local function append_parsed_tag(tags, key, payload, parser)
  tags[key] = tags[key] or {}
  local parsed = parser(payload)
  if parsed then
    insert(tags[key], parsed)
  end
end

local function with_tag_extra(payload, desc_extra)
  if not desc_extra or #desc_extra == 0 then
    return payload
  end
  local extra = join_desc(desc_extra)
  if not extra or extra == "" then
    return payload
  end
  if payload ~= "" then
    return payload .. "\n" .. extra
  end
  return extra
end

local PARSED_TAGS = {
  param = { key = "params", parser = parse_param },
  ["return"] = { key = "returns", parser = parse_return },
  field = { key = "fields", parser = parse_field },
  overload = { key = "overloads", parser = parse_overload },
}

local FLAG_TAGS = {
  nodiscard = true,
  private = true,
  protected = true,
  package = true,
  deprecated = true,
  ignore = true,
  enum = true,
}

local function parse_tags(tag_items)
  local tags = {}
  for i, item in ipairs(tag_items) do
    local tag = item.tag
    local payload = item.payload
    if tag == "alias" then
      local a = parse_alias_tag(payload, item.desc_extra)
      if a then
        tags.aliases = tags.aliases or {}
        insert(tags.aliases, a)
      end
    elseif tag == "name" or tag == "shortname" then
      local v = trim(payload)
      if v ~= "" then
        tags[tag] = set_view({ name = tag }, v)
      end
    elseif tag == "meta" then
      tags.meta = payload
      if item.desc_extra and #item.desc_extra > 0 then
        tags.meta_desc = join_desc(item.desc_extra)
      end
    elseif tag == "include" then
      local include_path = trim(payload)
      if include_path ~= "" then
        tags.includes = tags.includes or {}
        insert(tags.includes, include_path)
      elseif item.desc_extra and #item.desc_extra > 0 then
        local include_block = join_desc(item.desc_extra)
        if include_block and include_block ~= "" then
          tags.include_blocks = tags.include_blocks or {}
          insert(tags.include_blocks, include_block)
        end
      end
    else
      local parsed = PARSED_TAGS[tag]
      if parsed then
        if tag == "field" then
          -- Field descriptions in this codebase are written before the next
          -- field tag, so comments captured after the previous field/class tag
          -- should be attached to the current field.
          local prev = tag_items[i - 1]
          local lead_desc = prev and prev.desc_extra
          local can_shift = prev and (prev.tag == "field" or prev.tag == "class")
          payload = with_tag_extra(payload, can_shift and lead_desc or nil)
        else
          payload = with_tag_extra(payload, item.desc_extra)
        end
        append_parsed_tag(tags, parsed.key, payload, parsed.parser)
      elseif tag == "generic" then
        tags.generic = split_commas(payload)
      elseif FLAG_TAGS[tag] then
        tags[tag] = true
      elseif tag == "class" then
        tags.class = payload
      else
        local v = payload ~= "" and payload or nil
        tags[tag] = set_view({ name = tag }, v)
      end
    end
  end
  return tags
end

local function parse_function_name(line)
  local name = line:match("^%s*local%s+function%s+([%w_%.:]+)%s*%(")
  if not name then
    name = line:match("^%s*function%s+([%w_%.:]+)%s*%(")
  end
  if not name then
    return
  end
  return name, name:find(":", 1, true) ~= nil
end

local function parse_function_assignment(line)
  local bracket_name = line:match("^%s*[%w_%.:]+%[%s*['\"]([^'\"]+)['\"]%s*]%s*=%s*function%s*%(")
  if bracket_name then
    return bracket_name
  end
  return line:match("^%s*([%w_%.:]+)%s*=%s*function%s*%(")
end

local function parse_alias(line)
  local tbl, key, rhs = line:match("^%s*([%w_]+)%[%s*['\"]([^'\"]+)['\"]%s*]%s*=%s*([%w_%.:]+)%s*$")
  if tbl and key and rhs then
    if rhs == "true" or rhs == "false" or rhs == "nil" then
      return
    elseif rhs:match("^%d+$") or rhs:match("^%d+%.%d+$") then
      return
    end
    return key, rhs
  end

  local lhs, alias_rhs = line:match("^%s*([%w_%.:]+)%s*=%s*([%w_%.:]+)%s*$")
  if not lhs or not alias_rhs then
    return
  elseif alias_rhs == "true" or alias_rhs == "false" or alias_rhs == "nil" then
    return
  elseif alias_rhs:match("^%d+$") or alias_rhs:match("^%d+%.%d+$") then
    return
  end
  return lhs, alias_rhs
end

local function parse_module_table(line)
  return line:match("^%s*local%s+([%w_]+)%s*=%s*%{%s*%}%s*$")
end

local function parse_module_table_start(line)
  return line:match("^%s*local%s+([%w_]+)%s*=%s*%{(.*)$")
end

local function parse_enum_start(line)
  return line:match("^%s*local%s+([%w_]+)%s*=%s*%{(.*)$")
end

local function count_braces(s)
  local open = 0
  local close = 0
  for _ in s:gmatch("%{") do
    open = open + 1
  end
  for _ in s:gmatch("%}") do
    close = close + 1
  end
  return open - close
end

local function parse_enum_value(v)
  local t = trim(v)
  if t == "" then
    return
  elseif t:match('^".*"$') or t:match("^'.*'$") then
    return t:sub(2, -2)
  elseif t == "true" then
    return true
  elseif t == "false" then
    return false
  end
  local n = tonumber(t)
  if n ~= nil then
    return n
  end
  return t
end

local function parse_enum_body(body)
  local values = {}
  for part in body:gmatch("[^,]+") do
    local item = trim(part)
    if item ~= "" then
      local key, value = item:match("^%[(.-)%]%s*=%s*(.+)$")
      if key then
        values[trim(key)] = parse_enum_value(value)
      else
        local name, rhs = item:match("^([%w_]+)%s*=%s*(.+)$")
        if name then
          values[name] = parse_enum_value(rhs)
        else
          insert(values, parse_enum_value(item))
        end
      end
    end
  end
  return values
end

local function parse_field_assignment(line, table_name)
  if not table_name then
    return
  end
  local bracket_pattern = "^%s*" .. table_name .. "%[%s*['\"]([^'\"]+)['\"]%s*]%s*=%s*(.-)%s*$"
  local field, rhs = line:match(bracket_pattern)
  if not field then
    local pattern = "^%s*" .. table_name .. "%.([%w_]+)%s*=%s*(.-)%s*$"
    field, rhs = line:match(pattern)
  end
  if not field or not rhs then
    return
  end
  if rhs:match("%.") then
    return
  end
  return field, rhs
end

local function parse_symbol_reference(line)
  local name = line:match("^%s*local%s+([%w_%.:]+)%s*$")
  if name then
    return name
  end
  return line:match("^%s*([%w_%.:]+)%s*$")
end

local function parse_table_literal(src)
  local t = trim(src)
  local body = t:match("^%b{}$")
  if not body then
    return
  end
  body = t:sub(2, -2)
  local out = {}
  local idx = 1
  for part in body:gmatch("[^,]+") do
    local item = trim(part)
    if item ~= "" then
      local key, value = item:match("^%[(.-)%]%s*=%s*(.+)$")
      if key then
        key = trim(key)
        local v = parse_enum_value(value)
        out[key] = v
      else
        local name, rhs = item:match("^([%w_]+)%s*=%s*(.+)$")
        if name then
          out[name] = parse_enum_value(rhs)
        else
          out[idx] = parse_enum_value(item)
          idx = idx + 1
        end
      end
    end
  end
  return out
end

local function infer_view_from_value(value)
  local t = type(value)
  if t == "boolean" then
    return "boolean", value
  elseif t == "number" then
    if math.type and math.type(value) == "integer" then
      return "integer", value
    end
    return "number", value
  elseif t == "string" then
    return "string", value
  elseif t == "table" then
    return "table", value
  elseif t == "function" then
    return "function", value
  end
end

local function infer_view_from_literal(rhs)
  local t = trim(rhs)
  if t == "true" then
    return "boolean", true
  elseif t == "false" then
    return "boolean", false
  elseif t:match("^%d+$") then
    return "integer", tonumber(t)
  elseif t:match("^%d+%.%d+$") then
    return "number", tonumber(t)
  elseif t:match('^".*"$') or t:match("^'.*'$") then
    return "string", t:sub(2, -2)
  elseif t:match("^%b{}$") then
    local parsed = parse_table_literal(t)
    return "table", parsed or {}
  elseif t:match("^function%s*%(") or t:match("^function%s") then
    return "function"
  end
end

local function is_empty_table(t)
  return t == nil or next(t) == nil
end

local function deepcopy(v, seen)
  if type(v) ~= "table" then
    return v
  end
  if seen and seen[v] then
    return seen[v]
  end
  local s = seen or {}
  local out = {}
  s[v] = out
  for k, val in pairs(v) do
    out[deepcopy(k, s)] = deepcopy(val, s)
  end
  return out
end

local function take_item_name_overrides(tags)
  local function normalize_override_value(v)
    if type(v) ~= "string" then
      return v
    end
    v = trim(v)
    local lead = v:match("^`+")
    local trail = v:match("`+$")
    if lead and trail and #lead == #trail and #v > (#lead * 2) then
      v = v:sub(#lead + 1, #v - #trail)
    end
    return v
  end

  if type(tags) ~= "table" then
    return
  end

  local override_name = nil
  local override_shortname = nil

  if type(tags.name) == "table" and type(tags.name.view) == "string" and tags.name.view ~= "" then
    override_name = normalize_override_value(tags.name.view)
    tags.name = nil
  end
  if type(tags.shortname) == "table" and type(tags.shortname.view) == "string" and tags.shortname.view ~= "" then
    override_shortname = normalize_override_value(tags.shortname.view)
    tags.shortname = nil
  end

  local fields = tags.fields
  if type(fields) ~= "table" then
    return override_name, override_shortname
  end

  local kept = {}
  for _, field in ipairs(fields) do
    local key = field and field.name
    local value = field and field.view
    if key == "name" and not override_name and type(value) == "string" and value ~= "" then
      override_name = normalize_override_value(value)
    elseif key == "shortname" and not override_shortname and type(value) == "string" and value ~= "" then
      override_shortname = normalize_override_value(value)
    else
      insert(kept, field)
    end
  end

  tags.fields = #kept > 0 and kept or nil
  return override_name, override_shortname
end

local function parse(source)
  local out = {
    items = {},
  }

  local desc_lines = {}
  local tag_items = {}
  local block_start_line = nil
  local module_table = nil
  local implicit_fields = {}
  local enum_capture = nil
  local field_capture = nil
  local table_capture = nil

  local function reset_block()
    desc_lines = {}
    tag_items = {}
    block_start_line = nil
  end

  local function note_block_start(line_no)
    if not block_start_line then
      block_start_line = line_no
    end
  end

  local function add_implicit_field(name, view, value)
    insert(implicit_fields, { name = name, view = view, value = value })
  end

  local function flush_for_item(item, line_no)
    local tags = parse_tags(tag_items)
    local desc = join_desc(desc_lines)

    if tags.ignore then
      reset_block()
      return
    end

    if item.start == nil then
      item.start = block_start_line or line_no
    end
    if item.finish == nil then
      item.finish = line_no
    end

    if item.kind == "class" then
      tags.class = nil
      if not tags.overloads then
        tags.overloads = {}
      end
    end

    if item.kind == "function" and item.is_method == nil then
      if item.name and item.name:find(":", 1, true) then
        item.is_method = true
      elseif tags.params and tags.params[1] and tags.params[1].name == "self" then
        item.is_method = true
      else
        item.is_method = false
      end
    end

    if item.kind == "function" and item.is_method then
      tags.params = tags.params or {}
      if not tags.params[1] or tags.params[1].name ~= "self" then
        insert(tags.params, 1, { name = "self", view = "self" })
      end
    end

    if item.kind == "function" then
      item.view = "function"
    end

    local override_name, override_shortname = take_item_name_overrides(tags)
    if override_name then
      item.name = override_name
    end
    if override_shortname then
      item.shortname = override_shortname
    elseif override_name then
      item.shortname = shortname(override_name)
    end

    if item.name and not item.shortname then
      item.shortname = shortname(item.name)
    end

    item.desc = desc
    item.tags = tags

    insert(out.items, item)

    reset_block()
  end

  local function handle_comment_line(line, line_no)
    if line:match("^%s*%-%-%-@") then
      local tag, payload = line:match("^%s*%-%-%-@([%w_]+)%s*(.*)$")
      insert(tag_items, { tag = tag, payload = payload, desc_extra = {} })
      note_block_start(line_no)
    else
      local text = line:gsub("^%s*%-%-%-", "")
      if text:sub(1, 1) == " " and text:sub(2, 2) ~= " " then
        text = text:sub(2)
      end
      if #tag_items > 0 then
        local last_tag = tag_items[#tag_items].tag
        if last_tag == "name" or last_tag == "shortname" then
          insert(desc_lines, text)
        else
          insert(tag_items[#tag_items].desc_extra, text)
        end
      else
        insert(desc_lines, text)
      end
      note_block_start(line_no)
    end
  end

  local function finalize_enum_capture(line_no)
    if not enum_capture then
      reset_block()
      return
    end

    local lines = enum_capture.lines or {}
    if #lines == 0 then
      enum_capture = nil
      reset_block()
      return
    end

    local body = concat(lines, "\n")
    body = body:gsub("}%s*$", "")
    local values = parse_enum_body(body)
    insert(out.items, {
      kind = "enum",
      name = enum_capture.name,
      shortname = shortname(enum_capture.name),
      values = values,
      desc = enum_capture.desc,
      tags = enum_capture.tags or {},
      start = enum_capture.start_line,
      finish = line_no,
    })
    enum_capture = nil
    reset_block()
  end

  local function handle_enum_capture(line, line_no)
    if not enum_capture then
      return false
    end
    enum_capture.depth = enum_capture.depth + count_braces(line)
    insert(enum_capture.lines, line)
    if enum_capture.depth <= 0 then
      finalize_enum_capture(line_no)
    end
    return true
  end

  local function finalize_field_capture()
    if not field_capture then
      reset_block()
      return
    end

    local lines = field_capture.lines or {}
    if #lines == 0 then
      field_capture = nil
      reset_block()
      return
    end

    local rhs_full = concat(lines, "\n")
    local view, value = infer_view_from_literal(rhs_full)
    if view then
      add_implicit_field(field_capture.name, view, value)
    end
    field_capture = nil
    reset_block()
  end

  local function handle_field_capture(line)
    if not field_capture then
      return false
    end
    field_capture.depth = field_capture.depth + count_braces(line)
    insert(field_capture.lines, line)
    if field_capture.depth <= 0 then
      finalize_field_capture()
    end
    return true
  end

  local function finalize_table_capture()
    if not table_capture then
      reset_block()
      return
    end

    local lines = table_capture.lines or {}
    if #lines == 0 then
      table_capture = nil
      reset_block()
      return
    end

    local body = concat(lines, "\n")
    body = body:gsub("}%s*$", "")
    local parsed = parse_table_literal("{" .. body .. "}") or {}
    for key, value in pairs(parsed) do
      if type(key) == "string" then
        local view, field_value = infer_view_from_value(value)
        if view then
          add_implicit_field(key, view, field_value)
        end
      end
    end
    table_capture = nil
    reset_block()
  end

  local function handle_table_capture(line)
    if not table_capture then
      return false
    end
    table_capture.depth = table_capture.depth + count_braces(line)
    insert(table_capture.lines, line)
    if table_capture.depth <= 0 then
      finalize_table_capture()
    end
    return true
  end

  local function handle_function_line(line, line_no)
    local fn_name, is_method = parse_function_name(line)
    if fn_name then
      flush_for_item({ kind = "function", name = fn_name, is_method = is_method }, line_no)
      return true
    end

    local assign_name = parse_function_assignment(line)
    if assign_name then
      if #desc_lines > 0 or #tag_items > 0 then
        flush_for_item({ kind = "function", name = assign_name }, line_no)
      end
      return true
    end

    return false
  end

  local function handle_enum_start(line, line_no)
    local enum_tags = #tag_items > 0 and parse_tags(tag_items) or nil
    if not (enum_tags and enum_tags.enum) then
      return false
    end
    local enum_name, rest = parse_enum_start(line)
    if not enum_name then
      return false
    end
    local depth = 1 + count_braces(rest)
    enum_tags.enum = nil
    enum_capture = {
      name = enum_name,
      desc = join_desc(desc_lines),
      lines = { rest },
      depth = depth,
      tags = enum_tags,
      start_line = block_start_line or line_no,
    }
    if enum_capture.depth <= 0 then
      finalize_enum_capture(line_no)
    else
      reset_block()
    end
    return true
  end

  local function handle_field_assignment(line, line_no)
    local field_name, rhs = parse_field_assignment(line, module_table)
    if not (field_name and rhs) then
      return false
    end
    local rhs_trim = trim(rhs)
    if rhs_trim:match("^%{") and not rhs_trim:match("^%b{}%s*$") then
      field_capture = {
        name = field_name,
        lines = { rhs },
        depth = count_braces(rhs),
        start_line = line_no,
      }
      return true
    end
    local view, value = infer_view_from_literal(rhs)
    if view then
      add_implicit_field(field_name, view, value)
    end
    return true
  end

  local function handle_alias_assignment(line, line_no)
    local lhs, alias_rhs = parse_alias(line)
    if not (lhs and alias_rhs) then
      return false
    end
    if #desc_lines > 0 or #tag_items > 0 then
      flush_for_item({ kind = "alias", name = lhs, alias_of = alias_rhs }, line_no)
    else
      insert(out.items, {
        kind = "alias",
        name = lhs,
        shortname = shortname(lhs),
        alias_of = alias_rhs,
        tags = {},
        start = line_no,
        finish = line_no,
      })
    end
    return true
  end

  local function parse_variable_assignment(line)
    if type(line) ~= "string" then
      return nil
    end
    local name = line:match("^%s*local%s+([%a_][%w_]*)%s*=")
    if name then
      return name
    end
    name = line:match("^%s*([%a_][%w_]*)%s*=")
    return name
  end

  local function handle_tag_block(line, line_no)
    if #desc_lines == 0 and #tag_items == 0 then
      return
    end
    local tags = parse_tags(tag_items)
    if tags.ignore then
      reset_block()
      return
    end
    if tags.class then
      local class_view = tags.class
      local class_name = class_view:match("^%w+") or class_view
      tags.class = nil
      local var_name = parse_variable_assignment(line)
      flush_for_item({ kind = "class", name = class_name, view = class_view, var_name = var_name }, line_no)
    elseif tags.meta then
      local meta_desc = join_desc(desc_lines) or tags.meta_desc
      local meta_name = tags.meta
      insert(out.items, {
        kind = "meta",
        name = meta_name,
        shortname = shortname(meta_name),
        desc = meta_desc,
        tags = tags,
        start = block_start_line or line_no,
        finish = line_no,
      })
      reset_block()
    elseif tags.aliases and tags.aliases[1] and tags.aliases[1].name then
      local alias_desc = join_desc(desc_lines)
      local alias_tags = deepcopy(tags)
      alias_tags.aliases = nil
      for _, a in ipairs(tags.aliases) do
        insert(out.items, {
          kind = "alias",
          name = a.name,
          shortname = shortname(a.name),
          view = a.view,
          desc = a.desc or alias_desc,
          tags = deepcopy(alias_tags),
          start = block_start_line or line_no,
          finish = line_no,
        })
      end
      reset_block()
    elseif tags.type and tags.type.view then
      local symbol = parse_symbol_reference(line)
      local type_view = tags.type.view
      if symbol then
        tags.type = nil
        if type_view:match("^fun%(") then
          local params, returns = parse_fun_signature(type_view)
          if params then
            tags.params = params
            tags.returns = returns
          end
          insert(out.items, {
            kind = "function",
            name = symbol,
            shortname = shortname(symbol),
            start = block_start_line or line_no,
            finish = line_no,
            desc = join_desc(desc_lines),
            tags = tags,
            is_method = symbol:find(":", 1, true) ~= nil,
            view = "function",
          })
        else
          insert(out.items, {
            kind = "type",
            name = symbol,
            shortname = shortname(symbol),
            start = block_start_line or line_no,
            finish = line_no,
            desc = join_desc(desc_lines),
            tags = tags,
            view = type_view,
          })
        end
      end
      reset_block()
    elseif (tags.includes and #tags.includes > 0) or (tags.include_blocks and #tags.include_blocks > 0) then
      insert(out.items, {
        kind = "include",
        name = "include",
        shortname = "include",
        tags = tags,
        start = block_start_line or line_no,
        finish = line_no,
      })
      reset_block()
    else
      reset_block()
    end
  end

  local line_no = 0
  for line in (source .. "\n"):gmatch("(.-)\n") do
    line_no = line_no + 1
    if line:match("^%s*%-%-%-") then
      handle_comment_line(line, line_no)
    else
      local handled = false
      if handle_enum_capture(line, line_no) then
        handled = true
      elseif handle_field_capture(line) then
        handled = true
      elseif handle_table_capture(line) then
        handled = true
      end

      local module_table_name = nil
      local module_table_rest = nil
      if not handled then
        local mt = parse_module_table(line)
        if mt then
          module_table = module_table or mt
        else
          module_table_name, module_table_rest = parse_module_table_start(line)
          if module_table_name then
            module_table = module_table or module_table_name
          end
        end
      end

      if not handled and handle_function_line(line, line_no) then
        handled = true
      end

      if not handled and handle_enum_start(line, line_no) then
        handled = true
      end

      if not handled and handle_field_assignment(line, line_no) then
        handled = true
      end

      if not handled and handle_alias_assignment(line, line_no) then
        handled = true
      end

      if not handled then
        handle_tag_block(line, line_no)
      end

      if not handled and module_table_name and module_table_rest then
        table_capture = {
          name = module_table_name,
          lines = { module_table_rest },
          depth = 1 + count_braces(module_table_rest),
          start_line = line_no,
        }
        if table_capture.depth <= 0 then
          finalize_table_capture()
        end
      end
    end
  end

  local by_name = {}
  local first_class = nil
  for _, item in ipairs(out.items) do
    if item.kind == "class" then
      first_class = item
      break
    end
  end
  for _, item in ipairs(out.items) do
    if item.name then
      by_name[item.name] = item
    end
  end
  for _, item in ipairs(out.items) do
    if item.kind == "alias" and item.alias_of then
      local target = by_name[item.alias_of]
      if target then
        if item.desc == nil then
          item.desc = target.desc
        end
        if is_empty_table(item.tags) then
          item.tags = deepcopy(target.tags)
        end
      end
    end
  end

  local merged_aliases = {}
  local by_alias = {}
  for _, item in ipairs(out.items) do
    if item.kind == "alias" then
      local key = item.name or ""
      local existing = by_alias[key]
      if not existing then
        by_alias[key] = item
        insert(merged_aliases, item)
      elseif item.view and not existing.view then
        existing.view = item.view
      end
    else
      insert(merged_aliases, item)
    end
  end
  out.items = merged_aliases

  if first_class and #implicit_fields > 0 then
    first_class.tags = first_class.tags or {}
    first_class.tags.fields = first_class.tags.fields or {}
    local existing = {}
    for _, f in ipairs(first_class.tags.fields) do
      if f.name then
        existing[f.name] = true
      end
    end
    for _, f in ipairs(implicit_fields) do
      if not existing[f.name] then
        insert(first_class.tags.fields, f)
      end
    end
  end

  return out.items
end

local M = {
  parse = parse,
}
setmetatable(M, {
  __call = function(_, source)
    return parse(source)
  end,
})

return M
