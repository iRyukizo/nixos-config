{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;

    plugins = with pkgs; [
      rofi-calc
    ];

    font = "System San Francisco Display 18";
    terminal = "${pkgs.zsh}/bin/zsh";
    cycle = true;
    location = "center";
    theme = ./custom_nord.rasi;

    extraConfig = {
      modi = "combi,drun,run,window,ssh,calc";
      kb-remove-char-forward = "Delete";
      kb-remove-char-back = "BackSpace,Shift+BackSpace";
      kb-mode-next = "Control+Tab";
      kb-mode-previous = "Control+h,Control+ISO_Left_Tab";
      show-icons = false;
      matching = "fuzzy";
    };
  };
}
