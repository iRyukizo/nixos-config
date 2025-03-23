{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.my.home.urxvt;

  urxvt-font-size = pkgs.fetchFromGitHub {
    owner = "majutsushi";
    repo = "urxvt-font-size";
    rev = "0984499379e420de651dcfeedfbb7938867c44f8";
    sha256 = "9EYtFNL69skvvVDX5/cf3QrUIh6wwSfGxjYu7VCfowk=";
  };
  urxvt-perls = pkgs.fetchFromGitHub {
    owner = "muennich";
    repo = "urxvt-perls";
    rev = "05a3adc7b366a0d1782245eac035f9e74646511b";
    sha256 = "fC8EnvtpcYNrGZbL3W9MP/nKsThTU4Yo6AQiHpPne+8=";
  };
in
{
  options.my.home.urxvt = {
    enable = mkEnableOption "Urxvt home configuration";
  };

  config = mkIf cfg.enable {
    my.home = {
      fonts.enable = mkDefault true;
    };

    home.sessionVariables = {
      TERMINAL = "urxvt";
    };

    home.packages = with pkgs; [
      xclip
      perl
    ];

    home.file = {
      ".urxvt/ext/font-size".source = urxvt-font-size + "/font-size";
      ".urxvt/ext/keyboard-select".source = urxvt-perls + "/keyboard-select";
      ".urxvt/ext/url-select".source = urxvt-perls + "/deprecated/url-select";
      ".urxvt/ext/clipboard".source = urxvt-perls + "/deprecated/clipboard";
    };

    programs.urxvt = {
      enable = true;
      fonts = [
        "xft:MesloLGS NF:size=10"
      ];
      scroll = {
        bar = {
          enable = false;
        };
        scrollOnOutput = true;
      };
      transparent = true;
      shading = 30;
      extraConfig = {
        "mouseWheelScrollPage" = "false";
        "cursorBlink" = "true";

        "intensityStyles" = "false";
        "resize-font.smaller" = "C-Down";
        "resize-font.bigger" = "C-Up";
        "iso14755" = "false";
        "iso14755_52" = "false";

        "internalBorder" = "5";

        "perl-lib" = "${pkgs.rxvt-unicode-unwrapped}/lib/urxvt/perl/";
        "perl-ext-common" = "default,matcher,clipboard,url-select,keyboard-select,font-size";

        "copyCommand" = "xclip -i selection clipboard";
        "pasteCommand" = "xclip -o selection clipboard";

        "url-launcher" = "${pkgs.firefox}/bin/firefox";
        "urlLauncher" = "${pkgs.firefox}/bin/firefox";
        "underlineURLs" = "true";
        "urlButton" = "1";
        "keyboard-select.clipboard" = "true";
        "matcher.button" = "1";
        "matcher.pattern.1" = "\\\\bwww\\\\.[\\\\w-]+\\\\.]\\\\w./?&@#-]*[\\\\w/-]";

        "geometry" = "400x400";
      };
      keybindings = {
        "Shift-Control-V" = "eval:paste_clipboard";
        "Shift-Control-C" = "eval:selection_to_clipboard";

        "Control-Left" = "\\033[1;5D";
        "Shift-Control-Left" = "\\033[1;6D";
        "Control-Right" = "\\033[1;5C";
        "Shift-Control-Right" = "\\033[1;6C";
        "Control-Up" = "\\033[1;5A";
        "Shift-Control-Up" = "\\033[1;6A";
        "Control-Down" = "\\033[1;5B";
        "Shift-Control-Down" = "\\033[1;6B";

        "Shift-Down" = "command:\\033]720;1\\007";
        "Shift-Up" = "command:\\033]721;1\\007";

        "M-c" = "perl:clipboard:copy";
        "M-v" = "perl:clipboard:paste";
        "M-C-V" = "perl:clipboard:paste_escaped";
        "M-Escape" = "perl:keyboard-select:activate";
        "M-s" = "perl:keyboard-select:search";
        "M-u" = "perl:url-select:select_next";

        "M-plus" = "perl:font-size:increase";
        "M-minus" = "perl:font-size:decrease";
        "M-equal" = "perl:font-size:reset";
      };
    };
  };
}
