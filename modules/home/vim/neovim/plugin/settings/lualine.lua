local oil = require("oil")
local wk = require("which-key")

require("fidget").setup({})

local display_lsp_clients = true

local function list_clients(bufnr)
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local names = {}

    local clients_suffixes = {
        "_ls",
        "_lsp",
        "-lsp",
    }

    for _, client in ipairs(clients) do
        local client_name = client.name
        for _, suffix in ipairs(clients_suffixes) do
            if client_name:sub(-#suffix) == suffix then
                client_name = client_name:sub(1, -(#suffix + 1))
                break
            end
        end
        table.insert(names, client_name)
    end

    return names
end

local function list_lsp_clients()
    local client_names = list_clients(0)
    local sign = ""

    if #client_names == 0 then
        return ""
    end

    if not display_lsp_clients then
        return sign .. " " .. tostring(#client_names)
    end

    return sign .. " " .. table.concat(client_names, " ")
end

local function pretty_location()
    return string.format("%s%d%s%d", "\u{E0A1}", vim.fn.line("."), "\u{E0A3}", vim.fn.col("."))
end

local function list_spell_languages()
    if not vim.opt.spell:get() then
        return ""
    end

    return table.concat(vim.opt.spelllang:get(), ", ")
end

local function toggle_lsp_display()
    display_lsp_clients = not display_lsp_clients

    require("lualine").refresh()

    vim.notify("LSP Clients Display " .. (display_lsp_clients and "on" or "off"))
end

local diagnostics_enabled = true

local function toggle_diagnostics_display()
    diagnostics_enabled = not diagnostics_enabled

    require("lualine").refresh()

    vim.notify("Diagnostics Display " .. (diagnostics_enabled and "on" or "off"))
end

local gitinfo_display = true

local function toggle_gitinfo_display()
    gitinfo_display = not gitinfo_display

    require("lualine").refresh()

    vim.notify("Git Info Display " .. (gitinfo_display and "on" or "off"))
end

require("lualine").setup({
    options = {
        theme = "nord",
        globalstatus = false,
        icons_enabled = true,
    },

    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            {
                "branch",
                cond = function()
                    return gitinfo_display
                end,
            },
            {
                "diff",
                cond = function()
                    return gitinfo_display
                end,
            },
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                cond = function()
                    return diagnostics_enabled
                end,
            },
        },
        lualine_c = {
            {
                "filename",
                file_status = true,
            },
            {
                list_spell_languages,
            },
            {
                "custom_aerial",
                dense = true,
                dense_sep = ".",
                sep_highlight = "",
                sep_icon = " ",
                depth = vim.g.aerial_lualine_depth,
            },
        },
        lualine_x = {
            {
                list_lsp_clients,
            },
            {
                "filetype",
            },
        },
        lualine_y = {
            {
                "encoding",
                separator = "",
            },
            {
                "fileformat",
                separator = "",
            },
            {
                "searchcount",
                separator = "",
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
                separator = "",
            },
            {
                pretty_location,
                separator = "",
            },
        },
    },
    inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = { "encoding", "fileformat", "searchcount" },
        lualine_z = { { pretty_location } },
    },
    extensions = {
        "fugitive",
        "man",
        "quickfix",
        "aerial",
        {
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
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
                lualine_a = { "mode" },
                lualine_b = { "branch" },
            },
            filetypes = { "gitsigns-blame" },
        },
    },
})

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})

local function toggle_aerial_depth()
    vim.g.aerial_lualine_depth = vim.g.aerial_lualine_depth == nil and -1 or nil

    require("lualine").refresh()

    vim.notify("Aerial Lualine Depth: " .. tostring(vim.g.aerial_lualine_depth))
end

local function toggle_lualine_display()
    if
        vim.g.aerial_lualine_depth == nil
        or display_lsp_clients
        or diagnostics_enabled
        or gitinfo_display
    then
        vim.g.aerial_lualine_depth = -1
        display_lsp_clients = false
        diagnostics_enabled = false
        gitinfo_display = false
    else
        vim.g.aerial_lualine_depth = nil
        display_lsp_clients = true
        diagnostics_enabled = true
        gitinfo_display = true
    end

    require("lualine").refresh()

    vim.notify("Lualine full display " .. (display_lsp_clients and "on" or "off"))
end

local keys = {
    { "<leader>l", group = "Lualine" },
    { "<leader>lt", toggle_lualine_display, desc = "Toggle all display" },
    { "<leader>ll", toggle_lsp_display, desc = "Toggle LSP clients" },
    { "<leader>ld", toggle_diagnostics_display, desc = "Toggle Diagnostics display" },
    { "<leader>la", toggle_aerial_depth, desc = "Toggle Aerial Depth" },
    { "<leader>lg", toggle_gitinfo_display, desc = "Toggle git info display" },
}

wk.add(keys)
