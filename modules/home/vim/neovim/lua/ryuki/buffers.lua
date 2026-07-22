local M = {}

--- Get buffer name and remove extension
--- @param bufnr integer Buffer number
--- @return string Modified name
function M.basename_noext(bufnr)
    local full_path = vim.api.nvim_buf_get_name(bufnr)
    return vim.fn.fnamemodify(full_path, ":t:r")
end

--- Get buffer name and replace `-` by `_` and remove numbers
--- @param bufnr integer Buffer number
--- @return string Modified name
function M.underscore_name(bufnr)
    local full_path = vim.api.nvim_buf_get_name(bufnr)
    local basename = vim.fn.fnamemodify(full_path, ":t:r")
    return basename:gsub("%-", "_"):gsub("%.", "_"):gsub("%d", "")
end

return M
