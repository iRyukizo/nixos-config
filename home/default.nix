{ config, pkgs, ... }:

{
  imports = [
    ./bluetooth.nix
    ./devenv
    ./dunst.nix
    ./flameshot.nix
    ./fonts.nix
    ./git.nix
    ./go.nix
    ./gtk.nix
    ./i3
    ./programs.nix
    ./ranger.nix
    ./rofi
    ./spotify.nix
    ./urxvt.nix
    ./vim.nix
    ./xdg.nix
    ./xresources.nix
    ./zsh.nix
  ];

  home.stateVersion = "21.05";

  home.username = "ryuki";
}
