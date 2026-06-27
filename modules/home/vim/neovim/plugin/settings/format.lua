local lsp_format = require("lsp-format")
local wk = require("which-key")

lsp_format.setup({})

local format = vim.api.nvim_create_augroup("ryuki.format", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = format,
    callback = function(args)
        local buf, data = args.buf, args.data

        local client = assert(vim.lsp.get_client_by_id(data.client_id))
        lsp_format.on_attach(client, buf)
    end,
})

-- By default disable formatting on save for c language
lsp_format.disable({ args = "c" })

local function toggle_buffer_format_on_save()
    local ft = vim.bo.filetype
    lsp_format.toggle({ args = ft })
    vim.notify(
        "LSP Format on save for `"
            .. ft
            .. "` filetype "
            .. (lsp_format.disabled_filetypes[ft] and "disabled" or "enabled")
    )
end

local keys = {
    { "<leader>cF", toggle_buffer_format_on_save, desc = "Toggle format code" },
}

wk.add(keys)
