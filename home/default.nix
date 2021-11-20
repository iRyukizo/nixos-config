{ config, pkgs, ... }:

{
  imports = [
    ./vim.nix
    ./programs.nix
    ./git.nix
    ./gtk.nix
    ./i3.nix
    ./ranger.nix
    ./xresources.nix
    ./urxvt.nix
    ./xdg.nix
    ./zsh
    ./rofi
  ];

  home.stateVersion = "21.05";

  home.username = "ryuki";

  home.sessionVariables = {
    EDITOR = "vim";
    TERMINAL = "urxvt";
    MANPAGER = "less --mouse";
    PAGER = "less --mouse";
  };

  # TODO: setup go
  programs.go.enable = true;
}
