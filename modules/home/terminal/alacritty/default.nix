{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.my.home.terminal.alacritty;
in
{
  options.my.home.terminal.alacritty = {
    enable = mkEnableOption "Urxvt home configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # font
      meslo-lgs-nf
    ];

    home.sessionVariables = {
      TERMINAL = "alacritty";
    };

    services.picom = {
      enable = !pkgs.stdenv.isDarwin;
      settings = {
        backend = "glx";
        blur = {
          method = "dual_kawase";
          strength = 5;
        };
      };
    };

    programs.alacritty = {
      enable = true;

      settings = {
        window = {
          decorations = if pkgs.stdenv.isDarwin then "Buttonless" else "None";
          opacity = 0.6;
          blur = pkgs.stdenv.isDarwin;
          option_as_alt = "OnlyLeft";
        };

        mouse = {
          hide_when_typing = true;
        };

        font = {
          normal = {
            family = "MesloLGS NF";
            style = "Regular";
          };
          size =
            if !pkgs.stdenv.isDarwin
            then 12
            else 17;
        };

        colors = {
          primary = {
            background = "#2e3440";
            foreground = "#d8dee9";
            dim_foreground = "#a5abb6";
          };
          cursor = {
            text = "#2e3440";
            cursor = "#d8dee9";
          };
          vi_mode_cursor = {
            text = "#2e3440";
            cursor = "#d8dee9";
          };
          selection = {
            text = "CellForeground";
            background = "#4c566a";
          };
          search = {
            matches = {
              foreground = "CellBackground";
              background = "#88c0d0";
            };
          };
          normal = {
            black = "#3b4252";
            red = "#bf616a";
            green = "#a3be8c";
            yellow = "#ebcb8b";
            blue = "#81a1c1";
            magenta = "#b48ead";
            cyan = "#88c0d0";
            white = "#e5e9f0";
          };
          bright = {
            black = "#4c566a";
            red = "#bf616a";
            green = "#a3be8c";
            yellow = "#ebcb8b";
            blue = "#81a1c1";
            magenta = "#b48ead";
            cyan = "#8fbcbb";
            white = "#eceff4";
          };
          dim = {
            black = "#373e4d";
            red = "#94545d";
            green = "#809575";
            yellow = "#b29e75";
            blue = "#68809a";
            magenta = "#8c738c";
            cyan = "#6d96a5";
            white = "#aeb3bb";
          };
        };
      };
    };
  };
}
