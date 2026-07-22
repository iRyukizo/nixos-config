local M = {}

local cache = {}

--- Read ColumnLimit from `.clang-format` file
--- @param filepath string `.clang-format` filepath
--- @return integer? colorcolumn value
local function get_cc(filepath)
    if cache[filepath] ~= nil then
        return cache[filepath]
    end

    local limit = nil

    for line in io.lines(filepath) do
        limit = tonumber(line:match("^%s*ColumnLimit:%s*(%d+)"))
        if limit then
            break
        end
    end

    cache[filepath] = limit
    return limit
end

--- Search upward for `.clang-format` or `_clang-format`
--- @param start_dir string Directory to start the search
--- @return string? `clang-format` filepath
local function find_config(start_dir)
    local paths = { ".clang-format", "_clang-format" }

    local found = vim.fs.find(paths, {
        path = start_dir,
        upward = true,
        stop = vim.loop.os_homedir(),
    })

    return found[1]
end

--- Apply colorcolumn based on root folders' `.clang-format` ColumnLimit
--- @param bufnr integer? Buffer to start looking for (default: 0)
function M.set_cc(bufnr)
    bufnr = bufnr or 0

    local config_file = find_config(vim.api.nvim_buf_get_name(bufnr))

    if not config_file then
        vim.opt_local.colorcolumn = vim.opt.colorcolumn
        return
    end

    local limit = config_file and get_cc(config_file) or nil

    if limit and limit > 0 then
        vim.opt_local.colorcolumn = tostring(limit)
    else
        vim.opt_local.colorcolumn = vim.opt.colorcolumn
    end
end

--- Reload config if already present in cache
--- @param bufnr integer? Buffer to look for (default: 0)
function M.reload(bufnr)
    bufnr = bufnr or 0

    local config_file = find_config(vim.api.nvim_buf_get_name(bufnr))

    if config_file then
        cache[config_file] = nil
    end

    M.set_cc(bufnr)
end

--- Clear cache
--- @param filepath string? Filepath to clear (if empty clear all caches)
function M.clear_cache(filepath)
    if filepath then
        cache[filepath] = nil
    else
        cache = {}
    end
end

--- Cache debug helper
--- @return table Cache deepcopy
function M.cache()
    return vim.deepcopy(cache)
end

return M
