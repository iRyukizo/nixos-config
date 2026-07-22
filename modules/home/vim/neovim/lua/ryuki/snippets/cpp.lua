local ls = require("luasnip")
local buffers = require("ryuki.buffers")

local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node
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
                return buffers.basename_noext(0) .. ".hh"
            end),
        })
    ),
    s(
        "Inc",
        fmt([[#include <{header}>]], {
            header = i(1, "iostream"),
        })
    ),
    -- Header guards
    s("pra", { t("#pragma once") }),
    -- Main function
    s(
        "mainv",
        fmt(
            [[
                int main()
                {{
                    {statement}
                    return 0;
                }}
            ]],
            {
                statement = i(1, "/* code */"),
            }
        )
    ),
    -- For loops
    s(
        "fore",
        fmt(
            [[
                for ({const}{type} {elt} : {range})
                {{
                    {code}
                }}
            ]],
            {
                elt = i(1, "elt"),
                range = i(2, "range"),
                const = c(3, { t("const "), t("") }),
                type = i(4, "auto&"),

                code = i(5, "/* code */"),
            }
        )
    ),
    s(
        "iter",
        fmt(
            [[
                for ({cont_type}<{type}>::{iter} {var} = {container}.begin(); {rep_var} != {rep_container}.end(); ++{rep_var})
                {{
                    {code}
                }}
            ]],
            {
                cont_type = i(1, "std::vector"),
                type = i(2, "int"),
                iter = i(3, "const_iterator"),
                var = i(4, "i"),
                container = i(5, "container"),

                rep_var = rep(4),
                rep_container = rep(5),

                code = i(6, "/* code */"),
            }
        )
    ),
    s(
        "foriter",
        fmt(
            [[
                for (auto {var} = {container}.begin(); {rep_var} != {rep_container}.end(); ++{rep_var})
                {{
                    {code}
                }}
            ]],
            {

                var = i(1, "i"),
                container = i(2, "container"),

                rep_var = rep(1),
                rep_container = rep(2),

                code = i(3, "/* code */"),
            }
        )
    ),
    -- class
    s(
        "class",
        fmt(
            [[
                class {name}
                {{
                public:
                    {rep_name}({args});
                    virtual ~{rep_name}();

                private:
                    {data}
                }};
            ]],
            {
                name = di(1, function()
                    local cname = buffers.underscore_name(0)
                    return cname:sub(1, 1):upper() .. cname:sub(2)
                end),
                rep_name = rep(1),
                args = i(2, "/* arguments */"),
                data = i(3, "/* data */"),
            }
        )
    ),
    -- namespace
    s(
        "ns",
        fmt(
            [[
                namespace {name}
                {{
                    {code}
                }} // namespace {rep_name}
            ]],
            {
                name = di(1, function()
                    local nname = buffers.underscore_name(0)
                    return nname
                end),
                rep_name = rep(1),
                code = i(2, "/* code */"),
            }
        )
    ),
    -- template
    s(
        "tp",
        fmt(
            [[
                template <typename {name}>
            ]],
            {
                name = i(1, "T"),
            }
        )
    ),
    -- std useful
    s(
        "cout",
        fmt(
            [[
                std::cout << {token}{linebreak};
            ]],
            {
                token = i(1, '"Hello world!"'),
                linebreak = c(2, { t(' << "\\n"'), t(" << std::endl"), i(nil, "") }),
            }
        )
    ),
    s(
        "cin",
        fmt(
            [[
                std::cin >> {token};
            ]],
            {
                token = i(1, "token"),
            }
        )
    ),
    s(
        "cerr",
        fmt(
            [[
                std::cerr << {error}{linebreak};
            ]],
            {
                error = i(1, "error"),
                linebreak = c(2, { t(' << "\\n"'), t(" << std::endl"), i(nil, "") }),
            }
        )
    ),
    -- lambda
    s(
        "ld",
        fmt(
            [[
                [{catch}]({args}){{{code}}};
            ]],
            {
                catch = i(1, "/* catch */"),
                args = i(2, "/* arguments */"),
                code = i(3, "/* code */"),
            }
        )
    ),
    -- try ... catch ...
    s(
        "try",
        fmt(
            [[
                try
                {{
                    {code}
                }}
                catch ({error})
                {{
                    {error_handling}
                }}
            ]],
            {
                error = i(1, "const std::exception& e"),
                code = i(2, "/* code */"),
                error_handling = i(3, "/* error handling */"),
            }
        )
    ),
    -- methods
    s(
        "meth",
        fmt(
            [[
                {ret_type} {class}::{func}({param})
                {{
                    {code}
                }}
            ]],
            {
                class = di(1, function()
                    local cname = buffers.underscore_name(0)
                    return cname:sub(1, 1):upper() .. cname:sub(2)
                end),
                func = di(2, function()
                    local cname = buffers.underscore_name(0)
                    return cname .. "_f"
                end),
                ret_type = i(3, "void"),
                param = i(4, "/* parameters */"),
                code = i(5, "/* code */"),
            }
        )
    ),
}
