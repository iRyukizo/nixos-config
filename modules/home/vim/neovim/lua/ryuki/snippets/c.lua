local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local function buffer_basename_noext(bufnr)
    local full_path = vim.api.nvim_buf_get_name(bufnr)
    return vim.fn.fnamemodify(full_path, ":t:r")
end

local function buffer_headerguard_value(bufnr)
    local full_path = vim.api.nvim_buf_get_name(bufnr)
    local basename = vim.fn.fnamemodify(full_path, ":t")
    return basename:gsub("%-", "_"):gsub("%.", "_"):gsub("%d", ""):upper()
end

local function buffer_struct_name(bufnr)
    local full_path = vim.api.nvim_buf_get_name(bufnr)
    local basename = vim.fn.fnamemodify(full_path, ":t:r")
    return basename:gsub("%-", "_"):gsub("%.", "_"):gsub("%d", "") .. "_t"
end

return {
    -- Include directives
    s(
        "inc",
        fmt(
            [[#include "{header}"]],
            {
                    header = i(1, buffer_basename_noext(0) .. ".h"),
            }
        )
    ),
    s(
        "Inc",
        fmt(
            [[#include <{header}>]],
            {
                header = i(1, "stdio.h"),
            }
        )
    ),
    -- Header guards
    s(
        "once",
        fmt(
            [[
                #ifndef {value}
                #define {rep_value}

                {code}

                #endif /* {rep_value} */
            ]],
            {
                value = i(1, buffer_headerguard_value(0)),
                rep_value = rep(1),
                code = i(2)
            }
        )
    ),
    -- #define
    s(
        "def",
        fmt(
            [[$define {symbol} {value}]],
            {
                symbol = i(1, "SYMBOL"),
                value = i(2, "value"),
            }
        )
    ),
    s(
        "#if",
        fmt(
            [[
                #if {value}
                {code}
                #endif /* {rep_value} */
            ]],
            {
                value = i(1, "0"),
                rep_value = rep(1),
                code = i(2, "/* code */"),
            }
        )
    ),
    -- Main function
    s(
        "main",
        fmt(
            [[
                int main(int argc, char *argv[])
                {{
                    {statement}
                    return 0;
                }}
            ]],
            {
                statement = i(1, "/* code */")
            }
        )
    ),
    s(
        "mainv",
        fmt(
            [[
                int main(void)
                {{
                    {statement}
                    return 0;
                }}
            ]],
            {
                statement = i(1, "/* code */")
            }
        )
    ),
    -- For loops
    s(
        "for",
        fmt(
            [[
                for ({type} {var} = {init}; {rep_var} < {count}; {rep_var}++)
                {{
                    {code}
                }}
            ]],
            {
                var = i(1, "i"),
                init = i(2, "0"),
                rep_var = rep(1),
                count = i(3, "count"),
                type = i(4, "size_t"),

                code = i(5, "/* code */"),
            }
        )
    ),
    s(
        "forr",
        fmt(
            [[
                for ({init}; {condition}; {incr})

                {{
                    {code}
                }}
            ]],
            {
                init = i(1),
                condition = i(2),

                incr = i(3),
                code = i(4, "/* code */"),
            }
        )
    ),
    s(
        "fors",
        fmt(
            [[
                for (; *{string} != '\0'; {}++)
                {{
                    {code}
                }}
            ]],
            {
                string = i(1, "str"),
                rep(1),
                code = i(2, "/* code */"),
            }
        )
    ),
    -- While loops
    s(
        "wh",
        fmt(
            [[
                while ({condition})
                {{
                    {code}
                }}
            ]],
            {
                condition = i(1, "/* condition */"),
                code = i(2, "/* code */"),
            }
        )
    ),
    s(
        "do",
        fmt(
            [[
                do
                {{
                    {code}
                }} while ({condition});
            ]],
            {
                condition = i(1, "/* condition */"),
                code = i(2, "/* code */"),
            }
        )
    ),
    -- If statements
    s(
        "if",
        fmt(
            [[
                if ({condition})
                {{
                    {code}
                }}
            ]],
            {
                condition = i(1, "/* condition */"),
                code = i(2, "/* code */"),
            }
        )
    ),
    s(
        "elif",
        fmt(
            [[
                else if ({condition})
                {{
                    {code}
                }}

            ]],
            {
                condition = i(1, "/* condition */"),
                code = i(2, "/* code */"),
            }
        )
    ),
    s(
        "else",
        fmt(
            [[
                else
                {{
                    {code}
                }}
            ]],
            {
                code = i(1, "/* code */"),
            }
        )
    ),
    -- struct
    s(
        "struct",
        fmt(
            [[
                struct {name}
                {{
                    {data}
                }};
            ]],
            {
                name = i(1, buffer_struct_name(0)),
                data = i(2, "/* data */"),
            }
        )
    ),
    s(
        "enum",
        fmt(
            [[
                enum {name}
                {{
                    {data}
                }};
            ]],
            {
                name = i(1, "name"),
                data = i(2, "/* data */"),
            }
        )
    ),
    s(
        "td",
        fmt(
            [[typedef {type} {name};]],
            {
                type = i(1, "int"),
                name = i(2, "MyCustomType"),
            }
        )
    ),
    s(
        "tds",
        fmt(
            [[
                typedef struct
                {{
                    {data}
                }} {name};
            ]],
            {
                name = i(1, "MyCustomType"),
                data = i(2, "/* data */"),
            }
        )
    ),
    -- Printf
    s(
        "printf",
        fmt(
            [[printf("{string}"{format});]],
            {
                string = i(1, "%s"),
                format = d(2,
                    function(args)
                        local fmt = args[1][1]

                        if fmt:match("%%[%w]") then
                            return sn(nil, {
                                t(", "),
                                i(1, "var"),
                            })
                        end

                        return sn(nil, {})
                    end,
                    {1}
                ),
            }
        )
    ),
    s(
        "fprintf",
        fmt(
            [[fprintf({file}, "{string}"{format});]],
            {
                file = i(1, "stderr"),
                string = i(2, "%s"),
                format = d(3,
                    function(args)
                        local fmt = args[1][1]

                        if fmt:match("%%[%w]") then
                            return sn(nil, {
                                t(", "),
                                i(1, "var"),
                            })
                        end

                        return sn(nil, {})
                    end,
                    {1}
                ),
            }
        )
    ),
    -- switch
    s(
        "switch",
        fmt(
            [[
                switch ({variable})
                {{
                case {case}:
                    {code}
                    {brk}
                default:
                    {default_code}
                }}
            ]],
            {
                variable = i(1, "/* variable */"),
                case = i(2, "/* case */"),
                code = i(3, "/* code */"),
                brk = i(4, "break;"),
                default_code = i(5, "/* code */"),
            }
        )
    ),
    s(
        "case",
        fmt(
            [[
                case {case}:
                    {code}
                    {brk}
            ]],
            {
                case = i(1, "/* case */"),
                code = i(2, "/* code */"),
                brk = i(3, "break;"),
            }
        )
    ),
}
