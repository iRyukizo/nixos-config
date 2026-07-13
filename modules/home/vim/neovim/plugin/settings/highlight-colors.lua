local hc = require("nvim-highlight-colors")
local wk = require("which-key")

hc.setup({
    render = "virtual",

    virtual_symbol = "⬤",
    virtual_symbol_prefix = "",
    virtual_symbol_suffix = " ",

    virtual_symbol_position = "inline",
})

hc.turnOff()

local keys = {
    { "<leader>h", hc.toggle, desc = "Toggle Highlight Colors" },
}

wk.add(keys)
