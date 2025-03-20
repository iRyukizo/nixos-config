{ config, lib, pkgs, ... }:

{
  imports = [
    ./bluetooth.nix
    ./devenv
    ./dunst.nix
    ./flameshot.nix
    ./fonts.nix
    ./git.nix
    ./go.nix
    ./gpg.nix
    ./gtk.nix
    ./i3
    ./macos
    ./programs.nix
    ./ranger.nix
    ./rofi
    ./spotify.nix
    ./tmux.nix
    ./urxvt.nix
    ./vim.nix
    ./xdg.nix
    ./xresources.nix
    ./zsh.nix
  ];

  home.stateVersion = "25.05";

  home.username = lib.mkDefault "ryuki";
}
