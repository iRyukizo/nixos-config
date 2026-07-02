local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

local function make_rtable(args)
    local rows = tonumber(args[1][1]) or 0
    local cols = tonumber(args[2][1]) or 0

    if cols < 1 then
        return ""
    end

    local nodes = {}

    for c = 1, cols do
        table.insert(nodes, t("|_."))
        table.insert(nodes, i(c, "col" .. c))
    end
    table.insert(nodes, t("|"))

    for _ = 1, rows do
        table.insert(nodes, t({ "", "" }))
        local row = {}
        for _ = 1, cols do
            table.insert(row, "| ")
        end
        table.insert(nodes, t(table.concat(row) .. "|"))
    end

    return sn(nil, nodes)
end

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
                code = i(2, 'puts("here")'),
            }
        )
    ),
    s("rtable", {
        t("<!-- rows: "),
        i(1, "3"),
        t(" , cols: "),
        i(2, "4"),
        t({ "-->", "" }),
        d(3, make_rtable, { 1, 2 }),
    }),
}
