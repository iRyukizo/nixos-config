{ pkgs, ... }:

{
  imports = [
    ./vim.nix
    ./programs.nix
  ];

  home.stateVersion = "21.05";

  home.username = "ryuki";

  home.sessionVariables = { EDITOR = "vim"; TERMINAL = "urxvt"; MANPAGER = "less --mouse"; };

  programs.zsh.enable = true;
  programs.urxvt.enable = true;
}
