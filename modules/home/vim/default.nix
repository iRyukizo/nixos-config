{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption;

  cfg = config.my.home.vim;
in
{
  imports = [
    ./vim.nix
    ./neovim.nix
  ];

  options.my.home.vim = {
    enable = mkEnableOption "Home vim configuration";

    programs = {
      vim = mkEnableOption "Home vim vim option";
      neovim = mkEnableOption "Home vim neovim option" // { default = true; };
    };

    clangFormatSupport = mkEnableOption "Home vim-clang-format support" // { default = true; };
    ctagsSupport = mkEnableOption "Home vim ctags support" // { default = true; };
    goSupport = mkEnableOption "Home vim-go support" // { default = true; };
  };
}
