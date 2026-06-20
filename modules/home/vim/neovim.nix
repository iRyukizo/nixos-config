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
        # TODO: Add lsp config: clangd, golang
        # TODO: Add tags configs
        # TODO: Add luasnip, nvim-cmp
        # TODO: Check tree-sitter
        # TODO: Check telescope with fzf and dressings
        # TODO: Check null-ls for formating
        # TODO: Check aerial.nvim
        nord-nvim
        lualine-nvim
        # TODO: lsp-progress after lsp are setup

        which-key-nvim

        gitsigns-nvim
        git-messenger-vim

        vim-tmux-navigator

        vim-commentary
        vim-fugitive
        vim-obsession
        nvim-surround

        oil-nvim
      ];

      initLua = builtins.readFile ./neovim/init.lua;
    };
  };
}
