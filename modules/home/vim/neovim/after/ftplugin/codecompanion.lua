local wk = require("which-key")
local render_markdown = require("render-markdown")

local keys = {
    buffer = 0,
    { "<leader>mp", render_markdown.toggle, desc = "Toggle Markdown Render" },
}

wk.add(keys)
