local twilight = require("twilight")
local wk = require("which-key")

twilight.setup({
    dimming = {
        alpha = 0.2,
        color = { "Comment" },
        term_bg = "#616e88",
        inactive = false,
    },
    context = 16,
    treesitter = true,
    expand = {
        "function",
        "method",
        "struct",
        "class",
        "type_definition",
        "field_declaration_list",
        "table",
        "if_statement",
        "switch_statement",
    },
})

local keys = {
    { "<leader>t", group = "Focus" },
    { "<leader>tw", twilight.toggle, desc = "Toggle Twilight" },
}

wk.add(keys)
