{ pkgs, ... }:

{
  imports = [
    ./vim.nix
    ./programs.nix
    ./git.nix
    ./i3.nix
    ./xresources.nix
    ./urxvt.nix
  ];

  home.stateVersion = "21.05";

  home.username = "ryuki";

  home.sessionVariables = { EDITOR = "vim"; TERMINAL = "urxvt"; MANPAGER = "less --mouse"; };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  };
}
