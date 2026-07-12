local ibl = require("ibl")
local wk = require("which-key")

ibl.setup({
    enabled = false,
    scope = {
        enabled = true,
        show_start = false,
        show_end = false,
    },
    exclude = {
        filetypes = { "NvimTree" },
    },
})

local function toggle_ibl()
    if ibl.initialized then
        ibl.update({ enabled = not require("ibl.config").get_config(-1).enabled })
    else
        ibl.setup({})
    end
end

local keys = {
    { "<leader>i", toggle_ibl, desc = "Toggle blankline indent" },
}

wk.add(keys)
