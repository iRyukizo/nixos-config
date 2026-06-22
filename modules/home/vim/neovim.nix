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
        # TODO: Customize gitsigns
        # TODO: Check tree-sitter
        # TODO: Check telescope with fzf and dressings
        # TODO: Check beancount
        nord-nvim
        lualine-nvim
        lualine-lsp-progress

        which-key-nvim

        gitsigns-nvim
        git-messenger-vim

        # LSP
        nvim-lspconfig
        lsp-format-nvim
        none-ls-nvim

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

        vim-tmux-navigator

        vim-commentary
        vim-fugitive
        vim-obsession
        nvim-surround

        oil-nvim
      ];

      initLua = builtins.readFile ./neovim/init.lua;

      extraPackages = with pkgs; [
        clang-tools
        nixpkgs-fmt
        gopls
        bash-language-server
        typos-lsp
      ];
    };
  };
}
