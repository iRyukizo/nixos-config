local lfs = require("ryuki.lsp-format-save")
local wk = require("which-key")

lfs.setup({
    disabled_filetypes = {
        "c",
    },
})

local format = vim.api.nvim_create_augroup("ryuki.format", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = format,
    callback = function(args)
        local buf, data = args.buf, args.data
        local client = assert(vim.lsp.get_client_by_id(data.client_id))
        lfs.on_attach(client, buf)

        local keys = {
            buffer = 0,

            { "<leader>cF", lfs.toggle_current_buffer_filetype, desc = "Toggle format code" },
        }

        wk.add(keys)
    end,
})
