local wk = require("which-key")
local render_markdown = require("render-markdown")
local utils = require("ryuki.utils")
local md = require("ryuki.markdown")

local keys = {
    buffer = 0,

    { "<leader>m", group = "Markdown" },
    { "<leader>mc", md.toggle_code_blocks, desc = "Toggle Markdown/Textile Code blocks" },
    { "<leader>mh", md.toggle_headings, desc = "Toggle Markdown/Textile headings" },
    { "<leader>mt", md.toggle_tables, desc = "Toggle Markdown/Textile tables" },
    { "<leader>mp", render_markdown.toggle, desc = "Toggle Markdown Render" },
    {
        "<leader>mP",
        "<Cmd>!pandoc % -o %:r.pdf<CR>",
        desc = "Generate PDF",
        cond = utils.is_executable("pandoc"),
    },
    {
        "<leader>mb",
        "<Cmd>!pandoc -st beamer % -o %:r.pdf<CR>",
        desc = "Generate beamer PDF",
        cond = utils.is_executable("pandoc"),
    },
}

wk.add(keys)
