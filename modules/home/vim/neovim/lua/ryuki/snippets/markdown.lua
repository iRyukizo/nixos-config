local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

local function make_table(args, prefix, suffix, separator)
    local rows = tonumber(args[1][1]) or 0
    local cols = tonumber(args[2][1]) or 0

    if cols < 1 then
        return ""
    end

    local nodes = {}
    local sep = {}

    for c = 1, cols do
        table.insert(nodes, t("|" .. prefix))
        table.insert(nodes, i(c, "col" .. c))
        table.insert(nodes, t(suffix))
        if separator then
            table.insert(sep, " --- ")
        end
    end
    table.insert(nodes, t("|"))
    if separator then
        table.insert(nodes, t({ "", "|" .. table.concat(sep, "|") .. "|" }))
    end

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

local function make_rtable(args)
    return make_table(args, "_.", "", false)
end

local function make_mtable(args)
    return make_table(args, " ", " ", true)
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
                code = i(0, 'puts("here")'),
            }
        )
    ),
    s(
        "codeb",
        fmt(
            [[
                ```{lang}
                {code}
                ```
            ]],
            {
                lang = i(1, "c"),
                code = i(0, 'puts("here")'),
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
    s("table", {
        t("<!-- rows: "),
        i(1, "3"),
        t(" , cols: "),
        i(2, "4"),
        t({ "-->", "" }),
        d(3, make_mtable, { 1, 2 }),
    }),
    s(
        "beamerh",
        fmt(
            [[
                ---
                title:
                    \textbf{{{title}}}
                subtitle:
                    {subtitle}
                author: {author}
                institute: {institute}
                date: {date}
                section-titles: false
                lang: en-US
                beamer: true
                theme: Boadilla
                urlcolor: blue
                linkstyle: bold
                aspectratio: 169
                <!-- titlegraphic: TODEFINE.png -->
                <!-- logo: TODEFINE.png -->
                ---
            ]],
            {
                title = i(1, "Title"),
                subtitle = i(2, "Subtitle"),
                author = i(3, "Hugo Moreau"),
                institute = i(4, "Institute"),
                date = i(5, os.date("%Y-%m-%d")),
            }
        )
    ),
    s(
        "pandoch",
        fmt(
            [[
                ---
                title: "{title}"
                subtitle: "{subtitle}"
                author: "{author}"
                date: "{date}"
                format: pdf
                toc: true
                numbersections: true
                geometry:
                - top=2cm
                - bottom=1.5cm
                - left=1.5cm
                - right=1.5cm
                fontsize: 11pt
                documentclass: article
                classoption: "a4paper"
                mainfont: "Arial"
                sansfont: "Calibri"
                linkcolor: "#007bff"
                ---
            ]],
            {
                title = i(1, "Title"),
                subtitle = i(2, "Subtitle"),
                author = i(3, "Hugo Moreau"),
                date = i(4, os.date("%Y-%m-%d")),
            }
        )
    ),
}
