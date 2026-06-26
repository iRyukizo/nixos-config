local oil = require('oil')
local wk = require("which-key")

local function pretty_location()
    return string.format("%s%d%s%d",
        "\u{E0A1}", vim.fn.line("."), "\u{E0A3}", vim.fn.col("."))
end

local function list_clients(bufnr)
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local names = {}

    local clients_suffixes = {
        "_ls",
        "_lsp",
    }

    for _, client in ipairs(clients) do
        local client_name = client.name
        for _, suffix in ipairs(clients_suffixes) do
            if client_name:sub(-#suffix) == suffix then
                client_name = client_name:sub(1, -(#suffix+1))
                break
            end
        end
        table.insert(names, client_name)
    end

    return names
end
local function list_spell_languages()

    if not vim.opt.spell:get() then
        return ""
    end

    return table.concat(vim.opt.spelllang:get(), ", ")
end

local display_lsp_clients = true

local function toggle_lsp_display()
    display_lsp_clients = not display_lsp_clients

    require("lualine").refresh()

    vim.notify("LSP Clients Display " .. (display_lsp_clients and "on" or "off"))
end

local function list_lsp_clients()
    local client_names = list_clients(0)

    if #client_names == 0 then
        return ""
    end

    if not display_lsp_clients then
        return tostring(#client_names)
    end

    return table.concat(client_names, " ")
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
        lualine_x = { 
            {
                list_lsp_clients,
            },
            {
                'lsp_progress',
                separator = '',
            },
            {
                'filetype',
                separator = '',
            },
        },
        lualine_y = {
            {
                'encoding',
                separator = '',
            },
            {
                'fileformat',
                separator = '',
            },
            {
                'searchcount',
                separator = '',
            },
        },
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
                separator = '',
            },
            {
                pretty_location,
                separator = '',
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
        {
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch' },
            },
            filetypes = { 'gitsigns-blame' },
        },
    },
}

local keys = {
    { "<leader>ci", toggle_lsp_display, desc = "Toggle LSP clients" },
}

wk.add(keys)
