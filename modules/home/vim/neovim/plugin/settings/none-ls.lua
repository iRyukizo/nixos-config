local null_ls = require('null-ls')
local lsp = require('ryuki.lsp')

local function is_executable(cmd)
    return cmd and vim.fn.executable(cmd) == 1
end

local function partial(f, ...)
    local a = { ... }
    local a_len = select("#", ...)

    return function(...)
        local tmp = { ... }
        local tmp_len = select("#", ...)

        for i = 1, tmp_len do
            a[a_len + i] = tmp[i]
        end

        return f(unpack(a, 1, a_len + tmp_len))
    end
end

null_ls.setup({
    on_attach = lsp.on_attach,
})

null_ls.register({
    null_ls.builtins.formatting.nixpkgs_fmt.with({
        condition = partial(is_executable, "nixpkgs-fmt"),
    }),
})
