local render_markdown = require("render-markdown")

render_markdown.setup({
    enabled = false,
    overrides = {
        preview = {
            enabled = true,
        },
        buflisted = {},
        buftype = {
            nofile = {
                enabled = true,
                render_modes = true,
                padding = { highlight = "NormalFloat" },
                sign = { enabled = false },
            },
        },
        filetype = {},
    },
})
