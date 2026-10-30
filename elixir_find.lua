-- mod-version:3
local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local common = require "core.common"

-- TODO: `add std directory into project` command
-- TODO: regression tests for REGEX queries

local elixir = {
  extensions = {"ex", "exs"},
}

-------------------
-- Configuration --
-------------------

local include_list = {
  "**.ex",
  "**.exs",
}
local exclude_list = {
  --"build/*",
}

-----------------------
-- Configuration end --
-----------------------


-----------------------------
-- Regex builders & runner --
-----------------------------

local function regex_callable(word, kwds)
  local preprefix
  if not kwds then
    preprefix = "(def|defmacro|defp)"
  else
    preprefix = "("..table.concat(kwds, "|")..")"
  end
  return "\\b"..preprefix.."\\s+"..word.."(?=\\()"
end

local function run_regex_query(regex_query)
  -- open global search
  command.perform "project-search:find"

  -- get a reference to the current view
  ---@type core.view | widget
  local current_view = core.active_view
  core.add_thread(function()
    -- wait until project search becomes active active
    while not current_view.parent do
      coroutine.yield()
      current_view = core.active_view
    end
    ---@type plugins.projectsearch.resultsview
    local search_view = current_view.parent -- this holds the ref to searchview
    search_view.regex_toggle:set_toggle(true)
    search_view.sensitive_toggle:set_toggle(true)
    search_view.find_text:set_text(regex_query)

    search_view.filters_toggle:set_toggle(true)
    search_view.includes_text:set_text(table.concat(include_list, ", "))
    search_view.excludes_text:set_text(table.concat(exclude_list, ", "))

    search_view:refresh()
    -- wait until there are search results.
    while search_view.searching do coroutine.yield() end

    -- select first result
    search_view:swap_active_child()
    search_view.results_list:select_next()
    search_view.results_list:select_next()

    if search_view.results_list.total_results == 1 then
      search_view:open_selected_result()
      command.perform "project-search:find"
    end
  end)
end

---------------------------------
-- Regex builders & runner end --
---------------------------------


------------------------------------------
-- Input handling & identifier dispatch --
------------------------------------------

local function escape(s)
  return (s:gsub('[%-%.%+%[%]%(%)%$%^%%%?%*]','%%%1'))
end

local function get_identifier_under_cursor(dv)
  ---@cast dv core.docview
  command.perform "doc:select-word"
  local res = {}
  res.word = dv.doc:get_selection_text(1)

  local line1, col1, line2, col2 = dv.doc:get_selection(true)
 
  res.char_after = dv.doc:get_char(line2, col2)
  if res.char_after == "!" then
    res.word = res.word .. "!"
    res.char_after = dv.doc:get_char(line2, col2 + 1)
  end
  
  return res
end

function elixir.find(dv)

  local id = get_identifier_under_cursor(dv)
  if not id then return end

  if id.char_after == "(" then
    return run_regex_query(regex_callable(id.word))
  end
  
  core.log("idk how to query for "..id.word)
end

----------------------------------------------
-- Input handling & identifier dispatch end --
----------------------------------------------

return elixir
