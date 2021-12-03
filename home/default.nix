{ config, pkgs, ... }:

{
  imports = [
    ./dunst.nix
    ./git.nix
    ./go.nix
    ./gtk.nix
    ./i3
    ./programs.nix
    ./ranger.nix
    ./rofi
    ./urxvt.nix
    ./vim.nix
    ./xcursor.nix
    ./xdg.nix
    ./xresources.nix
    ./zsh.nix
  ];

  home.stateVersion = "21.05";

  home.username = "ryuki";

  home.sessionVariables = {
    EDITOR = "vim";
    TERMINAL = "urxvt";
    MANPAGER = "less --mouse";
    PAGER = "less --mouse";
  };

  home.sessionPath = [
    # Some packages are not packaged in go, so old `go install pkgs@version` makes it
    "$HOME/go/bin"
  ];
}
