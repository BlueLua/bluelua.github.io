return {
  -- Lua type files to ignore for individual API page generation.
  ignored_stems = { "ecodes", "evdev", "mods" },

  -- Minimum class fields required to render a quick-reference table.
  FIELD_OVERVIEW_MIN = 4,

  -- GitHub organization for type definition links.
  github_org = "BlueLua",

  -- The directory containing the types inside the GitHub repository.
  github_types_dir = "types",

  -- Site domain name for internal link resolution.
  domain = "bluelua.github.io",
}
