local oil = require("oil")
local wk = require("which-key")

local lsp_progress = require("lsp-progress")
local display_lsp_clients = true

lsp_progress.setup({
    client_format = function(client_name, spinner, series_messages)
        if #series_messages == 0 then
            return nil
        end
        return {
            name = client_name,
            body = spinner .. " " .. table.concat(series_messages, ", "),
        }
    end,
    format = function(client_messages)
        --- @param name string
        --- @param msg string?
        --- @return string
        local function stringify(name, msg)
            return msg and string.format("%s: %s", name, msg) or name
        end

        local sign = "" -- nf-fa-gear \uf013

        local lsp_clients = vim.lsp.get_clients({ bufnr = 0 })
        local messages_map = {}
        local clients_suffixes = {
            "_ls",
            "-ls",
            "_lsp",
        }
        for _, climsg in ipairs(client_messages) do
            messages_map[climsg.name] = climsg.body
        end

        if #lsp_clients > 0 then
            table.sort(lsp_clients, function(a, b)
                return a.name < b.name
            end)
            local builder = {}
            for _, cli in ipairs(lsp_clients) do
                local cli_name = cli.name
                for _, suffix in ipairs(clients_suffixes) do
                    if cli_name:sub(-#suffix) == suffix then
                        cli_name = cli_name:sub(1, -(#suffix + 1))
                        break
                    end
                end

                if
                    type(cli) == "table"
                    and type(cli.name) == "string"
                    and string.len(cli.name) > 0
                then
                    if messages_map[cli.name] then
                        table.insert(builder, stringify(cli_name, messages_map[cli.name]))
                    else
                        table.insert(builder, stringify(cli_name))
                    end
                end
            end
            if #builder > 0 then
                if display_lsp_clients then
                    return sign .. " " .. table.concat(builder, " ")
                else
                    return sign .. " " .. tostring(#builder)
                end
            end
        end
        return ""
    end,
})

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

require("lualine").setup({
    options = {
        theme = "nord",
        globalstatus = false,
        icons_enabled = true,
    },

    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_diagnostic" } } },
        lualine_c = { { "filename", file_status = true }, { list_spell_languages }, { "aerial" } },
        lualine_x = {
            {
                function()
                    return lsp_progress.progress()
                end,
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

local keys = {
    { "<leader>ci", toggle_lsp_display, desc = "Toggle LSP clients" },
}

wk.add(keys)
