local ls = require("luasnip")
local buffers = require("ryuki.buffers")

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- Dynamic Insert Node
local function di(pos, fn)
    return d(pos, function()
        return sn(nil, { i(1, fn()) })
    end)
end

return {
    -- Include directives
    s(
        "inc",
        fmt([[#include "{header}"]], {
            header = di(1, function()
                return buffers.basename_noext(0) .. ".h"
            end),
        })
    ),
    s(
        "Inc",
        fmt([[#include <{header}>]], {
            header = i(1, "stdio.h"),
        })
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
                value = di(1, function()
                    return buffers.underscore_name(0):upper()
                end),
                rep_value = rep(1),
                code = i(0, "/* code */"),
            }
        )
    ),
    -- #define
    s(
        "def",
        fmt([[#define {symbol} {value}]], {
            symbol = i(1, "SYMBOL"),
            value = i(2, "value"),
        })
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
                code = i(0, "/* code */"),
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
                statement = i(0, "/* code */"),
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
                statement = i(0, "/* code */"),
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

                code = i(0, "/* code */"),
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
                code = i(0, "/* code */"),
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
                code = i(0, "/* code */"),
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
                code = i(0, "/* code */"),
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
                code = i(0, "/* code */"),
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
                code = i(0, "/* code */"),
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
                code = i(0, "/* code */"),
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
                code = i(0, "/* code */"),
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
                name = di(1, function()
                    return buffers.underscore_name(0) .. "_t"
                end),
                data = i(0, "/* data */"),
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
                data = i(0, "/* data */"),
            }
        )
    ),
    s(
        "td",
        fmt([[typedef {type} {name};]], {
            type = i(1, "int"),
            name = i(2, "MyCustomType"),
        })
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
                data = i(0, "/* data */"),
            }
        )
    ),
    -- Printf
    s(
        "printf",
        fmt([[printf("{string}"{format});]], {
            string = i(1, "%s\\n"),
            format = d(2, function(args)
                local fmt = args[1][1]

                if fmt:match("%%[%w]") then
                    return sn(nil, {
                        t(", "),
                        i(1, "var"),
                    })
                end

                return sn(nil, {})
            end, { 1 }),
        })
    ),
    s(
        "fprintf",
        fmt([[fprintf({file}, "{string}"{format});]], {
            file = i(1, "stderr"),
            string = i(2, "%s\\n"),
            format = d(3, function(args)
                local fmt = args[1][1]

                if fmt:match("%%[%w]") then
                    return sn(nil, {
                        t(", "),
                        i(1, "var"),
                    })
                end

                return sn(nil, {})
            end, { 2 }),
        })
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
                default_code = i(0, "/* code */"),
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
                brk = i(2, "break;"),
                code = i(0, "/* code */"),
            }
        )
    ),
    s(
        "func",
        fmt(
            [[
                {ret_type} {func_name}({param})
                {{
                    {code}
                }}
            ]],
            {
                func_name = di(1, function()
                    return buffers.underscore_name(0) .. "_f"
                end),
                ret_type = i(2, "int"),
                param = i(3, "void"),
                code = i(0, "/* code */"),
            }
        )
    ),
    s(
        "decl",
        fmt(
            [[
                {ret_type} {func_name}({param});
            ]],
            {
                func_name = di(1, function()
                    return buffers.underscore_name(0) .. "_f"
                end),
                ret_type = i(2, "int"),
                param = i(3, "void"),
            }
        )
    ),
}
