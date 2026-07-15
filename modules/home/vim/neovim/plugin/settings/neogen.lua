local neogen = require("neogen")
local wk = require("which-key")

neogen.setup({
    snippet_engine = "luasnip",
})

local keys = {
    { "<leader>c", group = "Code" },
    { "<leader>ci", neogen.generate, desc = "Generate documentation" },
}

wk.add(keys)
