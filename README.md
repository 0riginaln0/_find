# _find

I hate LSP. They are slow and miserable and unstable.

I love go-to definition action.

I created [_find](https://github.com/0riginaln0/_find/).



[demo.mp4](https://github.com/user-attachments/assets/6095f143-452a-40be-88c3-d433943c6124)





## Supported languages:

- [c3](https://github.com/0riginaln0/_find/blob/main/c3_find.lua)
- [elixir](https://github.com/0riginaln0/_find/blob/main/elixir_find.lua) (can go-to erlang sources)
- [erlang](https://github.com/0riginaln0/_find/blob/main/elixir_find.lua)

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
  -- a bunch of other langs
  require ".yourfavlang_find", -- place yourfavlang below
}
```

## Suggestions

- Look at references
  - [yourfavlang_find.lua](https://github.com/0riginaln0/_find/blob/main/yourfavlang_find.lua) template
  - From the smallest to the largest: erlang_find.lua, elixir_find.lua, c3_find.lua
- Avoid false positives
  - If you can't find the symbol, just say "i can't find"
- Do regression tests for your regex queries
  - yes, I did not. don't be like me
