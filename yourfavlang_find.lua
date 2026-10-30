-- mod-version:3
local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local common = require "core.common"

local youfavlang = {
  extensions = { "youfavlang", "youfavlangscript" },
}

-------------------
-- Configuration --
-------------------

local include_list = {
  "**.youfavlang",
  "**.youfavlangscript",
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

function youfavlang.find(dv)
  core.log("idk how to query it")
end

----------------------------------------------
-- Input handling & identifier dispatch end --
----------------------------------------------

return youfavlang
