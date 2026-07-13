local lsp = require("ryuki.lsp")
local xc8_clangd = require("ryuki.lsp.xc8_clangd")

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    jump = {
        float = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "󰌵",
            [vim.diagnostic.severity.INFO] = "󰋼",
        },
    },
})

vim.api.nvim_set_hl(0, "LspInlayHint", {
    link = "Comment",
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("ryuki.lsp", { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        lsp.on_attach(client, args.buf)
    end,
})

local servers = {
    clangd = {
        -- We need to avoid xc8-clangd and clangd to clash
        root_dir = function(bufnr, on_dir)
            local root_markers = {
                ".clangd",
                ".clang-tidy",
                ".clang-format",
                "compile_commands.json",
                "compile_flags.txt",
                "configure.ac",
                ".git",
            }
            local root = vim.fs.root(bufnr, root_markers)
            local xc8 = vim.fs.root(bufnr, { ".xc8", "nbproject" })

            if xc8 then
                return nil
            end

            return on_dir(root)
        end,
    },
    xc8_clangd = xc8_clangd,
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
