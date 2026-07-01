local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "cc",
        fmt(
            [[
                {val}{par1}{scope}{par2}{excl}: {desc}
            ]],
            {
                val = c(1, {
                    t("feat"),
                    t("fix"),
                    t("refactor"),
                    t("perf"),
                    t("style"),
                    t("test"),
                    t("docs"),
                    t("build"),
                    t("ci"),
                    t("chore"),
                    t("revert"),
                }),
                scope = i(2, "scope"),
                par1 = d(5, function(args)
                    if args[1][1] ~= "" then
                       return sn(nil, { t("(") })
                    end
                    return sn(nil, {})
                end, { 2 }),
                par2 = d(6, function(args)
                    if args[1][1] ~= "" then
                       return sn(nil, { t(")") })
                    end
                    return sn(nil, {})
                end, { 2 }),

                excl = c(3, { t(""), t("!") }),
                desc = i(4, "commit description"),
            }
        )
    ),
    s(
        "redmine",
        fmt(
            [[
                [Redmine #{issue}]

                - {desc}

                Review: {reviewer}
            ]],
            {
                issue = i(1, "xxx"),
                desc = i(2, "Description"),
                reviewer = i(3, "Me"),
            }
        )
    ),
}
