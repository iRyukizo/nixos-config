local wk = require("which-key")

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

keys = {
    buffer = 0,

    { "<leader>m", group = "Markdown" },
    { "<leader>mh", toggle_headings, desc = "Toggle Markdown/Textile headings" },
}

wk.add(keys)
