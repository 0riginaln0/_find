# _find

I hate LSP. They are slow and miserable and unstable.

I love go-to symbol action.

I created [_find](https://github.com/0riginaln0/_find/).



[demo.mp4](https://github.com/user-attachments/assets/6095f143-452a-40be-88c3-d433943c6124)





## Supported languages:

- [c3](https://github.com/0riginaln0/_find/blob/main/c3_find.lua)
- [elixir](https://github.com/0riginaln0/_find/blob/main/elixir_find.lua)

## Installation

Git clone this repo into the `.config/pragtical/plugins`

## Design

Given the current document view and a [project search](https://github.com/pragtical/pragtical/blob/master/data/plugins/projectsearch.lua) plugin,
gather information about the symbol under the cursor, build a regex query to find its definition, execute the query.

Got a single match? Go-to it straight away!

Got several matches? Let the user choose the one they were looking for!


## Contributions

Create `yourfavlang_find.lua` plugin by implementing this interface:
```lua
-- Extensions table
yourfavlang.extensions -- A table of file extensions yourfavlang has
c3.extensions -- { "c3", "c3i" }
elixir.extensions -- { "ex", "exs" }

-- Find function
yourfavlang.find(dv) -- A function is provided with a docview parameter and shall perform a go-to / search action
c3.find(dv)
elixir.find(dv)
```

once `yourfavlang_find.lua` is implemented, add it into the [init.lua](https://github.com/0riginaln0/_find/blob/main/init.lua)
```lua
local langs = {
  require ".c3_find",
  require ".elixir_find",
  require ".yourfavlang_find", -- added
}
```

## Suggestions

- Look at references
  - [yourfavlang_find.lua](https://github.com/0riginaln0/_find/blob/main/yourfavlang_find.lua) template
  - [elixir_find.lua](https://github.com/0riginaln0/_find/blob/main/elixir_find.lua) is a simple one
  - [c3_find.lua](https://pragtical.dev/docs/developer-guide/core-ui-architecture#docview) is a more complex one. It gathers more info and even [prompts](https://pragtical.dev/docs/api/core#command_view) for an additional info when required.
- Avoid false positives
  - If you can't find the symbol, just say "i can't find"
- Do regression tests for your regex queries
  - yes, I did not. don't be like me
