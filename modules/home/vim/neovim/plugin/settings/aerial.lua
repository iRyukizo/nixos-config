local aerial = require("aerial")
local wk = require("which-key")

aerial.setup({
    backends = {
        ["c"] = { "lsp", "treesitter" },
        ["_"] = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
    },

    layout = {
        default_direction = "prefer_left",
    },

    filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
        "Field",
        "Variable",
    },
})

local keys = {
    { "<leader>c", group = "Code" },
    { "<leader>cA", aerial.toggle, desc = "Toggle Aerial" },
}

wk.add(keys)
