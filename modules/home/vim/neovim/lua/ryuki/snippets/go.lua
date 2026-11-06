local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "main",
        fmt(
            [[
                func main() {{
                    {statement}
                }}
            ]],
            {
                statement = i(0, "/* code */"),
            }
        )
    ),
    s(
        "init",
        fmt(
            [[
                func init() {{
                    {statement}
                }}
            ]],
            {
                statement = i(0, "/* code */"),
            }
        )
    ),
}
