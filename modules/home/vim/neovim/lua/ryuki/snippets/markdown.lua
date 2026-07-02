local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "rcode",
        fmt(
            [[
                <pre><code class="{lang}">
                    {code}
                </code></pre>
            ]],
            {
                lang = i(1, "c"), 
                code = i(2, "puts(\"here\")"),
            }
        )
    ),
}
