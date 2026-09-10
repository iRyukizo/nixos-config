local render_markdown = require("render-markdown")

render_markdown.setup({
    enabled = false,
    file_types = { "markdown", "codecompanion" },
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
