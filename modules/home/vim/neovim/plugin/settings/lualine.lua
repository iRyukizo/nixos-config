local oil = require('oil')

local function pretty_location()
    return string.format("%s%d%s%d",
        "\u{E0A1}", vim.fn.line("."), "\u{E0A3}", vim.fn.col("."))
end

local function list_clients(bufnr)
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local names = {}

    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end

    return names
end
local function list_spell_languages()

    if not vim.opt.spell:get() then
        return ""
    end

    return table.concat(vim.opt.spelllang:get(), ", ")
end

local function list_lsp_clients()
    local client_names = list_clients(0)

    if #client_names == 0 then
        return ""
    end

    return "[ " .. table.concat(client_names, " ") .. " ]"
end

require('lualine').setup {
    options = {
        theme = 'nord',
        globalstatus = false,
        icons_enabled = true,
    },

    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'nvim_diagnostic' } } },
        lualine_c = { { 'filename', file_status = true }, { list_spell_languages }},
        lualine_x = { { list_lsp_clients }, 'lsp_progress', 'filetype' },
        lualine_y = { 'encoding', 'fileformat', 'searchcount' },
        lualine_z = {
            {
                function()
                    local ok, status = pcall(vim.fn.ObsessionStatus)

                    if ok and status == "[$]" then
                        return "⚑"
                    end
                    if ok and status == "[S]" then
                        return "⚐"
                    end

                    return status
                end,
            },
            {
                pretty_location,
            },
        },
    },
    inactive_sections = {
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'encoding', 'fileformat', 'searchcount' },
        lualine_z = { { pretty_location } },
    },
    extensions = {
        "fugitive",
        "man",
        "quickfix",
        {
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch' },
                lualine_c = {
                    function()
                        return vim.fn.fnamemodify(oil.get_current_dir(), ":~")
                    end,
                },
            },
            filetypes = { "oil" },
        },
    },
}
