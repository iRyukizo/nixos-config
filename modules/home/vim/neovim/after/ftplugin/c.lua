vim.opt_local.comments = "s0:/*,mb:**,ex:*/"

--- Read ColumnLimit from `.clang-format` file
--- @param filepath string `.clang-format` filepath
--- @return integer? colorcolumn value
local function get_cf_cc(filepath)
    local file = io.open(filepath, "r")
    if not file then
        return nil
    end

    for line in file:lines() do
        local limit = line:match("^%s*ColumnLimit:%s*(%d+)")
        if limit then
            file:close()
            return tonumber(limit)
        end
    end

    file:close()
    return nil
end

--- Search upward for `.clang-format` or `_clang-format`
--- @return string? `clang-format` filepath
local function find_cf()
    local cwd = vim.fn.expand("%:p:h")
    local paths = { ".clang-format", "_clang-format" }

    while cwd and cwd ~= "/" do
        for _, name in ipairs(paths) do
            local candidate = cwd .. "/" .. name

            if vim.fn.filereadable(candidate) == 1 then
                return candidate
            end
        end
        cwd = vim.fn.fnamemodify(cwd, ":h")
    end
    return nil
end

--- Apply colorcolumn based on root folders' `.clang-format` ColumnLimit
local function set_cf_cc()
    local config_file = find_cf()
    local limit = config_file and get_cf_cc(config_file) or nil

    if limit and limit > 0 then
        vim.opt_local.colorcolumn = tostring(limit)
    end
end

-- TODO: Might be good to set this with lsp and refresh on clang-format update.
set_cf_cc()
