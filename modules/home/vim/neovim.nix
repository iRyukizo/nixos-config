{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf;

  cfg = config.my.home.vim;
  vimEnabled = cfg.programs.vim;
in
{
  config = mkIf (cfg.enable && cfg.programs.neovim) {
    programs.neovim = {
      enable = true;
      defaultEditor = !vimEnabled;

      viAlias = !vimEnabled;
      vimAlias = !vimEnabled;
      vimdiffAlias = !vimEnabled;

      plugins = with pkgs.vimPlugins; [
        # TODO: Add lsp config: clangd, golang
        # TODO: Add tags configs
        # TODO: Add luasnip, nvim-cmp
        # TODO: Check tree-sitter
        # TODO: Check telescope with fzf and dressings
        # TODO: Check which-key
        # TODO: Check null-ls for formating
        # TODO: Check aerial.nvim
        nord-nvim
        lualine-nvim
        # TODO: lsp-progress after lsp are setup

        gitsigns-nvim
        git-messenger-vim

        vim-tmux-navigator

        vim-commentary
        vim-fugitive
        vim-obsession
        nvim-surround

        oil-nvim
      ];

      # FIXME: Setup all of this in proper directories/files
      # TODO: Add after/ftplugin setup
      # TODO: stylua
      initLua = ''
        -- options
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

        -- colorscheme
        vim.opt.termguicolors = true

        vim.g.nord_disable_background = true
        vim.g.nord_cursorline_transparent = true
        vim.g.nord_contrast = true

        require('nord').set()

        -- oil.nvim
        local oil = require('oil')
        local detail = false

        oil.setup {
          view_options = {
              show_hidden = true,
              is_always_hidden = function(name, bufnr) 
                  return name == ".."
              end,
          },
          keymaps = {
              ["gd"] = {
                  desc = "Toggle file detail view",
                  callback = function()
                      detail = not detail
                      if detail then
                          oil.set_columns({ "icon", "permissions", "size", "mtime" })
                      else
                          oil.set_columns({ "icon" })
                      end
                  end,
              },
          },
        }

        -- lualine
        require('lualine').setup {
          options = {
            theme = 'nord',
            globalstatus = false,
            icons_enabled = true,
          },

          sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { { 'filename', file_status = true } },
            lualine_x = { 'lspstatus', 'filetype' },
            lualine_y = { 'encoding', 'fileformat', 'searchcount' },
            lualine_z = {
              {
                function()
                  local ok, status = pcall(vim.fn.ObsessionStatus)

                  if ok and status == "[$]" then
                    return "⚑"
                  end
                  if ok and status == "[S]" then
                    return "⚐"
                  end

                  return status
                end,
              },
              {
                function()
                  return string.format("%s%d%s%d",
                  "\u{E0A1}", vim.fn.line("."), "\u{E0A3}", vim.fn.col("."))
                end,
              },
            },
          },
          extensions = {
            "fugitive",
            "man",
            "quickfix",
            {
              sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch' },
                lualine_c = {
                  function()
                      return vim.fn.fnamemodify(oil.get_current_dir(), ":~")
                  end,
                  },
                },
              filetypes = { "oil" },
            },
          },
        }
      '';
    };
  };
}
