{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf nameValuePair;

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
        lualine-lsp-progress

        # Which-key
        which-key-nvim

        # Git
        gitsigns-nvim
        git-messenger-vim

        # Telescope
        dressing-nvim
        telescope-fzf-native-nvim
        telescope-nvim

        # LSP
        nvim-lspconfig
        lsp-format-nvim
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

        # Better than NetrW
        oil-nvim
      ];

      initLua = builtins.readFile ./neovim/init.lua;

      extraPackages = with pkgs; [
        clang-tools
        nixpkgs-fmt
        gopls
        bash-language-server
        typos-lsp
        ripgrep
      ];
    };
  };
}
