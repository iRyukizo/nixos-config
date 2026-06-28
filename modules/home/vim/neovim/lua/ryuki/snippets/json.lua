local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "vimlua",
        fmt(
            [[
                "workspace": {{
                  "library": ["$VIMRUNTIME"]
                }}
            ]],
            {}
        )
    ),
}
