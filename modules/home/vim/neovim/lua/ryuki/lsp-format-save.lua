local M = {
    enabled = true,
    disabled_filetypes = {},
}

--- Toggle current buffer filetype format on save
function M.toggle_current_buffer_filetype()
    local ft = vim.bo.filetype

    M.toggle({ args = ft })

    vim.notify(
        string.format(
            "Format on save for '%s' filetype %s",
            ft,
            M.disabled_filetypes[ft] and "disabled" or "enabled"
        )
    )
end

--- Toggle format on save
--- @param opts table Filetype to toggle (if empty, toggle global format)
function M.toggle(opts)
    if opts.args == "" then
        M.enabled = not M.enabled
    else
        M.disabled_filetypes[opts.args] = not M.disabled_filetypes[opts.args]
    end
end

--- Disable format on save
--- @param opts table Filetype to toggle (if empty, disable global format)
function M.disable(opts)
    if opts.args == "" then
        M.enabled = false
    else
        M.disabled_filetypes[opts.args] = true
    end
end

--- Enable format on save
--- If summoned with bang, enable everything
--- @param opts table Filetype to enable (if empty, enable global format)
function M.enable(opts)
    if opts.bang then
        M.disabled_filetypes = {}
        M.enabled = true
    elseif opts.args == "" then
        M.enabled = true
    else
        M.disabled_filetypes[opts.args] = false
    end
end

--- To be summoned with `LspAttach`
--- @param client vim.lsp.Client
--- @param bufnr integer?
function M.on_attach(client, bufnr)
    if not client:supports_method("textDocument/formatting") then
        return
    end
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local group = vim.api.nvim_create_augroup("RyukiLspFormatOnSave", { clear = false })

    vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = group,
        event = "BufWritePre",
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        desc = "Ryuki Lsp Format On Save",
        buf = bufnr,
        callback = function()
            local ft = vim.bo.filetype
            if M.enabled and M.disabled_filetypes[ft] ~= true then
                vim.lsp.buf.format({ async = false })
            end
        end,
    })
end

--- Set up format_on_save
--- @param opts table? Optional parameters:
--- - disabled_filetypes: filetypes to be disabled by default
function M.setup(opts)
    if opts and opts.disabled_filetypes and type(opts.disabled_filetypes) ~= "table" then
        error("Expected a table (list) as opts.disabled_filetypes")
    end

    if opts then
        for _, value in ipairs(opts.disabled_filetypes) do
            M.disabled_filetypes[value] = true
        end
    end

    vim.api.nvim_create_user_command(
        "RFormatToggle",
        M.toggle,
        { nargs = "?", bar = true, complete = "filetype", force = true }
    )
    vim.api.nvim_create_user_command(
        "RFormatDisable",
        M.disable,
        { nargs = "?", bar = true, complete = "filetype", force = true }
    )
    vim.api.nvim_create_user_command(
        "RFormatEnable",
        M.enable,
        { nargs = "?", bar = true, complete = "filetype", force = true, bang = true }
    )
end

return M
