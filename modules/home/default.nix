{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    ./aerospace.nix
    ./bat.nix
    ./bluetooth.nix
    ./devenv.nix
    ./direnv.nix
    ./dunst.nix
    ./flameshot.nix
    ./fonts.nix
    ./fzf.nix
    ./git.nix
    ./go.nix
    ./gpg.nix
    ./gtk.nix
    ./i3
    ./nix.nix
    ./programs.nix
    ./ranger.nix
    ./rofi
    ./secrets.nix
    ./spotify.nix
    ./ssh.nix
    ./terminal
    ./tmux.nix
    ./token.nix
    ./vim.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = rec {
    stateVersion = "25.05";
    username = lib.mkDefault "ryuki";
    homeDirectory = lib.mkDefault "/home/${username}";
  };
}
