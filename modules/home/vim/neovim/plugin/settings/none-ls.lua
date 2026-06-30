local null_ls = require("null-ls")
local lsp = require("ryuki.lsp")
local fmt = null_ls.builtins.formatting

local function is_executable(cmd)
    return cmd and vim.fn.executable(cmd) == 1
end

local function fmt_source(source, bin, opts)
    opts = opts or {}
    opts.condition = function()
        return is_executable(bin)
    end
    return source.with(opts)
end

null_ls.setup({
    on_attach = lsp.on_attach,
})

null_ls.register({
    fmt_source(fmt.nixpkgs_fmt, "nixpkgs-fmt"),
    fmt_source(fmt.stylua, "stylua"),
    fmt_source(fmt.black, "black", { extra_args = { "--fast" } }),
    fmt_source(fmt.prettier, "prettier", {
        filetypes = {
            "javascript",
            "typescript",
            "css",
            "html",
            "json",
            "jsonc",
            "yaml",
        },
    }),
})
