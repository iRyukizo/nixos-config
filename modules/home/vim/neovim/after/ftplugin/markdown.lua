local wk = require("which-key")
local render_markdown = require("render-markdown")
local utils = require("ryuki.utils")

local function toggle_headings()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    local has_h_style = false
    for _, line in ipairs(lines) do
        if line:match("^h[1-4]%.%s+") then
            has_h_style = true
            break
        end
    end

    for i, line in ipairs(lines) do
        if has_h_style then
            line = line:gsub("^h4%.%s+(.*)$", "#### %1")
            line = line:gsub("^h3%.%s+(.*)$", "### %1")
            line = line:gsub("^h2%.%s+(.*)$", "## %1")
            line = line:gsub("^h1%.%s+(.*)$", "# %1")
        else
            line = line:gsub("^####%s+(.*)$", "h4. %1")
            line = line:gsub("^###%s+(.*)$", "h3. %1")
            line = line:gsub("^##%s+(.*)$", "h2. %1")
            line = line:gsub("^#%s+(.*)$", "h1. %1")
        end
        lines[i] = line
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

local function split_table_cells(line)
    local cells = {}
    for cell in line:gmatch("|([^|]+)") do
        table.insert(cells, vim.trim(cell))
    end
    return cells
end
local function markdown_header_to_textile(line)
    local cells = split_table_cells(line)
    for i, cell in ipairs(cells) do
        cells[i] = "_." .. cell
    end
    return "|" .. table.concat(cells, "|") .. "|"
end
local function textile_header_to_markdown(line)
    local cells = split_table_cells(line)
    for i, cell in ipairs(cells) do
        cells[i] = cell:gsub("^_%.%s*", "")
    end
    return "| " .. table.concat(cells, " | ") .. " |"
end
local function is_markdown_separator(line)
    local cells = split_table_cells(line)
    if #cells == 0 then
        return false
    end
    for _, cell in ipairs(cells) do
        if not cell:match("^:?-+:?$") then
            return false
        end
    end
    return true
end
local function toggle_tables()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local has_textile = false
    for _, line in ipairs(lines) do
        if line:match("^|") and line:match("|_.") then
            has_textile = true
            break
        end
    end
    local out = {}
    local i = 1
    while i <= #lines do
        local line = lines[i]
        if has_textile then
            -- Textile -> Markdown
            if line:match("^|") and line:match("|_.") then
                local header = textile_header_to_markdown(line)
                table.insert(out, header)
                local cols = #split_table_cells(header)
                local separator = {}
                for _ = 1, cols do
                    table.insert(separator, "---")
                end
                table.insert(out, "| " .. table.concat(separator, " | ") .. " |")
            else
                table.insert(out, line)
            end
            i = i + 1
        else
            -- Markdown -> Textile
            local next_line = lines[i + 1]
            if line:match("^|") and next_line and is_markdown_separator(next_line) then
                table.insert(out, markdown_header_to_textile(line))
                i = i + 2
            else
                table.insert(out, line)
                i = i + 1
            end
        end
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
end

local function toggle_code_blocks()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local has_redmine = false
    for _, line in ipairs(lines) do
        if line:match("^<pre><code") then
            has_redmine = true
            break
        end
    end
    local out = {}
    local i = 1
    while i <= #lines do
        local line = lines[i]
        if has_redmine then
            -- Textile -> Markdown
            local lang = line:match('^<pre><code class="([^"]*)">')
            if lang then
                table.insert(out, "```" .. lang)
                i = i + 1
                while i <= #lines and not lines[i]:match("^</code></pre>$") do
                    table.insert(out, lines[i])
                    i = i + 1
                end
                table.insert(out, "```")
            else
                table.insert(out, line)
            end
        else
            -- Markdown -> Textile
            local lang = line:match("^```([%w_+-]*)$")
            if lang then
                table.insert(out, string.format('<pre><code class="%s">', lang))
                i = i + 1
                while i <= #lines and not lines[i]:match("^```$") do
                    table.insert(out, lines[i])
                    i = i + 1
                end
                table.insert(out, "</code></pre>")
            else
                table.insert(out, line)
            end
        end
        i = i + 1
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
end

local keys = {
    buffer = 0,

    { "<leader>m", group = "Markdown" },
    { "<leader>mc", toggle_code_blocks, desc = "Toggle Markdown/Textile Code blocks" },
    { "<leader>mh", toggle_headings, desc = "Toggle Markdown/Textile headings" },
    { "<leader>mt", toggle_tables, desc = "Toggle Markdown/Textile tables" },
    { "<leader>mp", render_markdown.toggle, desc = "Toggle Markdown Render" },
    {
        "<leader>mP",
        "<Cmd>!pandoc % -o %:r.pdf<CR>",
        desc = "Generate PDF",
        cond = utils.is_executable("pandoc"),
    },
    {
        "<leader>mb",
        "<Cmd>!pandoc -st beamer % -o %:r.pdf<CR>",
        desc = "Generate beamer PDF",
        cond = utils.is_executable("pandoc"),
    },
}

wk.add(keys)
