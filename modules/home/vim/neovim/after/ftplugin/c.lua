local cf = require("ryuki.clang-format")

vim.opt_local.comments = "s0:/*,mb:**,ex:*/"

cf.set_cc()

vim.api.nvim_buf_create_user_command(0, "CCReload", function()
    cf.reload()
end, {
    desc = "Reload Colomn Color config from clang-format",
})
