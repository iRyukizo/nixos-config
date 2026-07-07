local M = require("lualine.components.aerial"):extend()

vim.g.aerial_lualine_depth = nil

function M:init(options)
    M.super.init(self, options)

    self.get_status = self.get_status_new_depth_normal

    if self.options.dense then
        self.get_status = self.get_status_new_depth_dense
    end
end

function M:get_status_new_depth()
    self.options.depth = vim.g.aerial_lualine_depth

    return self:get_status_normal()
end

function M:get_status_new_depth_dense()
    self.options.depth = vim.g.aerial_lualine_depth

    return self:get_status_dense()
end

return M
