{ lib, ... }:

{
  imports = [
    ./aerospace.nix
    ./bat.nix
    ./bluetooth.nix
    ./ctags.nix
    ./delta.nix
    ./devenv.nix
    ./direnv.nix
    ./dircolors.nix
    ./dunst.nix
    ./flameshot.nix
    ./fonts.nix
    ./fzf.nix
    ./git.nix
    ./go.nix
    ./gpg.nix
    ./gtk.nix
    ./i3
    ./less.nix
    ./man.nix
    ./nix-index.nix
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
    ./vim
    ./wsl.nix
    ./xdg.nix
    ./zsh.nix
  ];

  home = rec {
    stateVersion = "26.05";
    username = lib.mkDefault "ryuki";
    homeDirectory = lib.mkDefault "/home/${username}";
  };
}
