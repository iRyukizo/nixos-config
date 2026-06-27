local wk = require("which-key")

local keys = {
    { "<leader><leader>", vim.cmd.nohlsearch, desc = "Clear search highlight" },
}

wk.add(keys)
