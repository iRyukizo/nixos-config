local oil = require('oil')

local function pretty_location()
    return string.format("%s%d%s%d",
        "\u{E0A1}", vim.fn.line("."), "\u{E0A3}", vim.fn.col("."))
end

require('lualine').setup {
    options = {
        theme = 'nord',
        globalstatus = false,
        icons_enabled = true,
    },

    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', file_status = true } },
        lualine_x = { 'lspstatus', 'filetype' },
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
