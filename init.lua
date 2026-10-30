-- mod-version:3.0
-- priority:100

local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"

local langs = {
  require ".c3_find",
  require ".elixir_find",
}

local function table_contains(t, element)
  for _, value in pairs(t) do
    if value == element then
      return true
    end
  end
  return false
end

local function in_findable_file(extensions)
  local doc = core.active_view.doc
  local filename = doc:get_name()
  local extension = filename and filename:match("%.([^%.]+)$") or ""
  return table_contains(extensions, extension)
end

local function dispatch_find(dv)
  for index, lang in ipairs(langs) do
    local can_dispatch = in_findable_file(lang.extensions)
    if can_dispatch and lang.find then
      lang.find(dv)
      return
    end
  end
end

command.add("core.docview", {
  ["_find"] = dispatch_find,
})

keymap.add {
  ["f12"] = "_find",
  ["alt+d"] = "_find",
}
