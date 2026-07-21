local M = {}

--- Checks if a given command is executable
--- @param cmd string? command to check
--- @return boolean returns true if command is executable
M.is_executable = function(cmd)
    return cmd and vim.fn.executable(cmd) == 1
end

return M
