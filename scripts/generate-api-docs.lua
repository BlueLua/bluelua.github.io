local insert = table.insert
local sort = table.sort

local script_path = debug.getinfo(1, "S").source:gsub("^@", "")
local script_dir = script_path:match("^(.*)/[^/]*$") or "."
local lls = dofile(script_dir .. "/luals-type-parser.lua")
local render = dofile(script_dir .. "/render-api-docs.lua")

local function shell_quote(s)
  return "'" .. tostring(s):gsub("'", [['"'"']]) .. "'"
end

local function exists_dir(path)
  local ok = os.execute("[ -d " .. shell_quote(path) .. " ]")
  return ok == true or ok == 0
end

local function mkdir_p(path)
  assert(os.execute("mkdir -p " .. shell_quote(path)))
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

local function list_type_files(path)
  local p = assert(io.popen("ls -1 " .. shell_quote(path), "r"))
  local out = {}
  for line in p:lines() do
    if line:match("%.lua$") and line:sub(1, 1) ~= "_" then
      insert(out, line)
    end
  end
  p:close()
  sort(out)
  return out
end

local function page_stem(filename)
  return filename:gsub("%.d%.lua$", ""):gsub("%.lua$", ""):lower()
end

local function render_type_file(types_dir, filename)
  local content = read_file(types_dir .. "/" .. filename)
  return render(lls.parse(content))
end

local function generate_docs(types_dir, output_dir, project_name)
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
    if stem ~= project_name then
      local markdown = render_type_file(types_dir, filename)
      write_file(output_dir .. "/" .. stem .. ".md", markdown)
      generated = generated + 1
    end
  end
  return { output_dir = output_dir, files = generated }
end

local function usage()
  return "usage: lua scripts/generate-api-docs.lua [types-dir] [output-dir] [project-name]\n"
end

local types_dir = (arg and arg[1]) or "types"
local output_dir = (arg and arg[2]) or "docs"
local project_name = (arg and arg[3]) or nil
if types_dir == "-h" or types_dir == "--help" then
  io.stdout:write(usage())
  os.exit(0)
end

local result = generate_docs(types_dir, output_dir, project_name)
io.stdout:write(string.format("generated %d doc file(s) in %s\n", result.files, result.output_dir))
