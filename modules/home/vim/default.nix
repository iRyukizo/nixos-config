{ config, lib, pkgs, ... }:

let
  inherit (lib) literalExpression mkEnableOption mkOption types;

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

    type = mkOption {
      type = types.enum [ "standard" "darwin" "remote" "wsl" ];
      default = "standard";
      example = literalExpression ''standard'';
      description = ''
        Type of system (default: standard).
        Options: standard darwin remote wsl
      '';
    };

    options = {
      # Really laggy (powershell might be the cause)
      # FIXME: Find a better alternative (win32yank?)
      # The problem being pasting from windows to wsl, we get Carriage return character
      # Might be a fix to manually define a function to remove them
      wslClipboard = mkEnableOption "Home vim wsl linked clipboard";
    };

    clangFormatSupport = mkEnableOption "Home vim-clang-format support" // { default = true; };
    ctagsSupport = mkEnableOption "Home vim ctags support" // { default = true; };
    goSupport = mkEnableOption "Home vim-go support" // { default = true; };
  };
}
