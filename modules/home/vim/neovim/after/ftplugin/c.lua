local cf = require("ryuki.clang-format")

vim.opt_local.comments = "s0:/*,mb:**,ex:*/"

-- TODO: Might be good to set this with lsp and refresh on clang-format update.
cf.set_cf_cc()
