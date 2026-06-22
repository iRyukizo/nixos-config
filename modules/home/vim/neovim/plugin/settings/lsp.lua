local lsp = require("ryuki.lsp")

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    jump = {
        float = true,
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
    capabilities = capabilities,
    on_attach = lsp.on_attach,
})

local servers = {
    clangd = {},
    nil_ls = {},
    bashls = {
        filetypes = { "bash", "sh", "zsh" },
        settings = {
            bashIde = {
                shfmt = {
                    simplifyCode = true,
                    caseIndent = true,
                },
            },
        },
    },
    gopls = {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
            },
        },
    },
    harper_ls = {},
    typos_lsp = {},
}

for server, config in pairs(servers) do
    if not vim.tbl_isempty(config) then
        vim.lsp.config(server, config)
    end
    vim.lsp.enable(server)
end
