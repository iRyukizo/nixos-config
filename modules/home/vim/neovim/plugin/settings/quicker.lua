local quicker = require("quicker")
local wk = require("which-key")

quicker.setup({
    keys = {
        {
            ">",
            function()
                require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
            end,
            desc = "Expand quickfix context",
        },
        {
            "<",
            function()
                require("quicker").collapse()
            end,
            desc = "Collapse quickfix context",
        },
    },
})

vim.api.nvim_set_hl(0, "QuickFixLine", {
    link = "StatusLine",
})

local keys = {
    { "<leader>q", quicker.toggle, desc = "Toggle quickfix" },
}

wk.add(keys)
