{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf nameValuePair optional;
  inherit (lib.strings) optionalString;

  neovimConfigFiles =
    let
      toSource = dir: { source = ./neovim + "/${dir}"; };
      configureDirectory = name: nameValuePair "nvim/${name}" (toSource name);
      linkDirectories =
        dirs: builtins.listToAttrs (map configureDirectory dirs);
    in
    linkDirectories [
      "after"
      "ftdetect"
      "lua"
      "plugin"
    ];

  cfg = config.my.home.vim;
  vimEnabled = cfg.programs.vim;
in
{
  config = mkIf (cfg.enable && cfg.programs.neovim) {
    xdg.configFile = neovimConfigFiles;

    programs.neovim = {
      enable = true;
      defaultEditor = !vimEnabled;

      viAlias = !vimEnabled;
      vimAlias = !vimEnabled;
      vimdiffAlias = !vimEnabled;

      plugins = with pkgs.vimPlugins; [
        # Theme
        nord-nvim
        lualine-nvim
        fidget-nvim

        # Which-key
        which-key-nvim

        # Git
        gitsigns-nvim
        git-messenger-vim

        # Telescope
        dressing-nvim
        telescope-fzf-native-nvim
        telescope-live-grep-args-nvim
        telescope-nvim

        # LSP
        nvim-lspconfig
        none-ls-nvim

        # Treesitter
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects

        # Completion
        # TODO: Add custom luasnip snippets
        luasnip
        nvim-cmp
        cmp-async-path
        cmp-buffer
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-nvim-tags
        cmp-under-comparator
        cmp_luasnip

        # Tmux
        vim-tmux-navigator

        # Tpope basics
        vim-commentary
        vim-fugitive
        vim-obsession
        nvim-surround
        vim-endwise

        # Better than NetrW
        oil-nvim

        # UI Improvement
        aerial-nvim
        nvim-web-devicons
        lspkind-nvim
        nvim-highlight-colors

        render-markdown-nvim

        indent-blankline-nvim
        neogen
      ];

      initLua = builtins.readFile ./neovim/init.lua + optionalString
        (cfg.type == "wsl"
          && cfg.options.wslClipboard) ''
        vim.g.clipboard = {
            name = 'WslClipboard',
            copy = {
                ['+'] = 'clip.exe',
                ['*'] = 'clip.exe',
            },
            paste = {
                ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            },
            cache_enabled = 0,
        }
      '';

      extraPackages = with pkgs; [
        nixpkgs-fmt

        ripgrep

        #Formatter
        black
        stylua
        prettier

        # LSP
        bash-language-server
        clang-tools
        gopls
        harper
        nil
        pyright
        ruff
        typos-lsp
        lua-language-server
      ] ++ optional cfg.options.xc8Support pkgs.ryuki.microchip-xc8;
    };
  };
}
