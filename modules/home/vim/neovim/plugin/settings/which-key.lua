local wk = require("which-key")

wk.setup({
    win = {
        border = "rounded",
        no_overlap = true,
    },
})

local keys = {
    { "<leader><leader>", vim.cmd.nohlsearch, desc = "Clear search highlight" },
}

wk.add(keys)
