local render_markdown = require("render-markdown")

render_markdown.setup({
    enabled = false,
    overrides = { preview = { enabled = true } },
})
