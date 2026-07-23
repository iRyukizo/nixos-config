local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")
local telescope_builtin = require("telescope.builtin")
local lga = require("telescope").extensions.live_grep_args
local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
local wk = require("which-key")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = "which_key",
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        live_grep_args = {
            auto_quoting = true,
            mappings = {
                i = {
                    ["<C-o>"] = lga_actions.quote_prompt(),
                    ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    ["<C-space>"] = lga_actions.to_fuzzy_refine,
                },
            },
        },
    },
})

telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")

local keys = {
    { "<leader>f", group = "Fuzzy finder" },
    { "<leader>fb", telescope_builtin.buffers, desc = "Open buffers" },
    { "<leader>ff", telescope_builtin.git_files, desc = "Git tracked files" },
    { "<leader>fF", telescope_builtin.find_files, desc = "Files" },
    { "<leader>fg", lga.live_grep_args, desc = "Grep string" },
    { "<leader>fG", lga_shortcuts.grep_word_under_cursor, desc = "Grep string under cursor" },
    {
        "<leader>fm",
        function()
            telescope_builtin.man_pages({ sections = { "1", "2", "3" } })
        end,
        desc = "Man pages",
    },
    { "<leader>fr", telescope_builtin.lsp_references, desc = "LSP References" },
    { "<leader>fc", telescope_builtin.lsp_incoming_calls, desc = "LSP Incoming Calls" },
    { "<leader>fC", telescope_builtin.lsp_outgoing_calls, desc = "LSP Outgoing Calls" },
    {
        "<leader>fd",
        function()
            telescope_builtin.diagnostics({ bufnr = 0 })
        end,
        desc = "LSP Diagnostics buffer",
    },
    { "<leader>fD", telescope_builtin.diagnostics, desc = "LSP Diagnostics" },
    { "<leader>fl", telescope_builtin.git_bcommits, desc = "Git buffercommits" },
    { "<leader>fL", telescope_builtin.git_commits, desc = "Git commits" },
    { "<leader>fs", telescope_builtin.treesitter, desc = "Treesitter symbols" },
    { "<leader>fS", telescope_builtin.lsp_document_symbols, desc = "LSP Document Symbols" },
    { "<leader>fq", telescope_builtin.quickfix, desc = "Current Quickfix list" },
}

wk.add(keys)
