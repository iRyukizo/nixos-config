local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "src",
        fmt(
            [[
                {src}={files}
            ]],
            {
                src = i(1, "SRC"),
                files = i(2, "files"),
            }
        )
    ),
    s(
        "obj",
        fmt(
            [[
                {obj}=${{{src}:{ft1}={ft2}}}
            ]],
            {
                obj = i(1, "OBJ"),
                src = i(2, "SRC"),
                ft1 = i(3, ".c"),
                ft2 = i(4, ".o"),
            }
        )
    ),
    s(
        "bin",
        fmt(
            [[
                {bin}={binary}
            ]],
            {
                bin = i(1, "BIN"),
                binary = i(2, "binary"),
            }
        )
    ),
    s(
        "lib",
        fmt(
            [[
                {lib}={library}
            ]],
            {
                lib = i(1, "LIB"),
                library = i(2, "library.a"),
            }
        )
    ),
    s(
        "cc",
        fmt(
            [[
                CC=gcc
                CFLAGS=-Wall -Wextra -Werror -pedantic -std=c99{fsanitize}{debug} {exit}
                LDFLAGS= {fsanitize_rep}
            ]],
            {
                exit = i(0),
                fsanitize = i(1, " -fsanitize=address"),
                fsanitize_rep = rep(1),
                debug = i(2, " -g"),
            }
        )
    ),
    s("cxx", {
        t({
            "CXX=g++",
            "CXXFLAGS=-Wall -Wextra -Werror -pedantic -std=c++20",
        }),
    }),
    s(
        "cpp",
        fmt(
            [[
                CPPFLAGS={cppflags}
            ]],
            {
                cppflags = i(1, "-Isrc/"),
            }
        )
    ),
    s(
        "clean",
        fmt(
            [[
                clean:
                {tab}{rm} {obj} {bin}
            ]],
            {
                tab = t("\t"),
                rm = i(1, "${RM}"),
                obj = i(2, "${OBJ}"),
                bin = i(3, "${BIN}"),
            }
        )
    ),
    s(
        "ph",
        fmt(
            [[
                .PHONY: {all} {clean} {check}
            ]],
            {
                all = i(1, "all"),
                clean = i(2, "clean"),
                check = i(3, "check"),
            }
        )
    ),
    s(
        "rule",
        fmt(
            [[
                {rule}: {dep}
                {tab}{command} {dep_rep} -o {rule_rep}
            ]],
            {
                tab = t("\t"),
                rule = i(1, "${BIN}"),
                dep = i(2, "${OBJ}"),
                command = i(3, "${CC}"),
                dep_rep = rep(2),
                rule_rep = rep(1),
            }
        )
    ),
    s(
        "all",
        fmt(
            [[
                {all}: {bin}
            ]],
            {
                all = i(1, "all"),
                bin = i(2, "${BIN}"),
            }
        )
    ),
}
