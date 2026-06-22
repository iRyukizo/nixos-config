local lsp_format = require('lsp-format')

lsp_format.setup({})

local format = vim.api.nvim_create_augroup("ryuki.format", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = format,
    callback = function(args)
        local buf, data = args.buf, args.data
        local ft = vim.bo[buf].filetype

        if ft ~= "c" then
            local client = assert(vim.lsp.get_client_by_id(data.client_id))
            lsp_format.on_attach(client, buf)
        end
    end,
})
