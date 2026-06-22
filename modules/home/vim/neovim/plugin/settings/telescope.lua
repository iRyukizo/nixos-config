local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
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
    },
})

telescope.load_extension("fzf")

local keys = {
    { "<leader>f", group = "Fuzzy finder" },
    { "<leader>fb", telescope_builtin.buffers, desc = "Open buffers" },
    { "<leader>ff", telescope_builtin.git_files, desc = "Git tracked files" },
    { "<leader>fF", telescope_builtin.find_files, desc = "Files" },
    { "<leader>fg", telescope_builtin.live_grep, desc = "Grep string" },
    { "<leader>fG", telescope_builtin.grep_string, desc = "Grep string under cursor" },
    {
        "<leader>fm",
        function()
            telescope_builtin.man_pages({ sections = { "1", "2", "3" } })
        end,
        desc = "Man pages",
    },
    { "<leader>fr", telescope_builtin.lsp_references, desc = "LSP References" },
    { "<leader>fd", telescope_builtin.lsp_definitions, desc = "LSP Definitions" },
    { "<leader>fc", telescope_builtin.lsp_incoming_calls, desc = "LSP Incoming Calls" },
    { "<leader>fC", telescope_builtin.lsp_outgoing_calls, desc = "LSP Outgoing Calls" },
    { "<leader>fD", telescope_builtin.diagnostics, desc = "LSP Diagnostics" },
    { "<leader>fc", telescope_builtin.git_bcommits, desc = "Git buffercommits" },
    { "<leader>fC", telescope_builtin.git_commits, desc = "Git commits" },
    { "<leader>fs", telescope_builtin.treesitter, desc = "Treesitter symbols" },
    { "<leader>fS", telescope_builtin.lsp_document_symbols, desc = "LSP Document Symbols" },
}

wk.add(keys)
