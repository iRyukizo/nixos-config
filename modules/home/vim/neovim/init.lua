vim.opt.number = true
vim.opt.mouse = "a"

vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true

vim.opt.colorcolumn = "80"
vim.opt.cursorline = true

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.list = true
vim.opt.listchars = {
    tab = ">-",
    eol = "¬",
    trail = "-",
}
vim.opt.ruler = true

vim.opt.tabstop = 8
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.guicursor = "n-v-i-c:block-Cursor"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.completeopt = { "menu", "menuone", "preview", "noselect" }

vim.opt.clipboard = "unnamedplus"

vim.opt.modeline = false

-- Theme
vim.opt.termguicolors = true

vim.g.nord_disable_background = true
vim.g.nord_cursorline_transparent = true
vim.g.nord_contrast = true

require("nord").set()
