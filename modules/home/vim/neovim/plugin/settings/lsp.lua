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
    nil_ls = {
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
    },
    pyright = {
        settings = {
            pyright = {
                disableOrganizeImports = true,
                python = {
                    analysis = {
                        typeCheckingMode = "standard",
                        autoImportCompletion = true,
                        reportUnusedImport = "none",
                        reportUnusedVariable = "none",
                    },
                },
            },
        },
    },
    ruff = {
        init_options = {
            settings = {
                organizeImports = true,
                showSyntaxErrors = true,
                lint = {
                    enable = true,
                },
                format = {
                    enable = true,
                },
            },
        },
    },
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
    harper_ls = {
        root_markers = { ".harper_dict.txt", ".harper_dictionary.txt", ".git" },
        settings = {
            ["harper-ls"] = {
                userDictPath = vim.fn.expand("~/.config/nvim/harper_dict.txt"),
                workspaceDictPath = ".harper_dict.txt",
                linters = {
                    SpellCheck = true,
                    SpelledNumbers = true,
                    AnA = true,
                    SentenceCapitalization = false,
                    UnclosedQuotes = true,
                    WrongQuotes = true,
                    LongSentences = false,
                    RepeatedWords = true,
                    Spaces = true,
                    Matcher = true,
                    CorrectNumberSuffix = false,
                    NumberSuffixCapitalization = false,
                    MultipleSequentialPronouns = true,
                    LinkingVerbs = true,
                    AvoidCurses = false,
                    TerminatingCunjuctions = true,
                },

                diagnosticSeverity = "hint",
                codeActions = {
                    forceStable = true,
                },
            },
        },
    },
    typos_lsp = {},
    lua_ls = {
        settings = {
            Lua = {
                format = {
                    enable = false,
                },
                runtime = { version = "LuaJIT" },
                workspace = {
                    ignoreDir = {
                        ".git",
                        ".direnv",
                        "result*",
                    },
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    },
}

for server, config in pairs(servers) do
    if not vim.tbl_isempty(config) then
        vim.lsp.config(server, config)
    end
    vim.lsp.enable(server)
end
