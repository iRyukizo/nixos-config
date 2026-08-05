local tv = require("tunnelvision")
local wk = require("which-key")

tv.setup({
    mode = "dynamic",
    scope = "buffer",
    sources = {
        tv.combine("lsp", "treesitter"),
        "treesitter",
        "word",
    },
})

local keys = {
    { "<leader>t", group = "Focus" },
    { "<leader>tt", tv.toggle, desc = "Toggle TunnelVision" },
    {
        "<leader>tf",
        function()
            if tv.is_active() then
                tv.off()
                return
            end

            tv.on({ scope = "function" })
        end,
        desc = "Toggle TunnelVision function",
    },
    { "<leader>t[", tv.prev, desc = "Previous TunnelVision" },
    { "<leader>t]", tv.next, desc = "Next TunnelVision" },
}

wk.add(keys)
