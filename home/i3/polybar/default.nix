{ lib, pkgs, config, ... }:

with lib;
let
  inherit (builtins) map genList length listToAttrs toString;

  cfg = config.my.home.polybar;

  batteryModule = types.submodule {
    options = {
      battery = mkOption {
        type = types.str;
        description = ''
          Battery device name.
        '';
      };

      adpater = mkOption {
        type = types.str;
        description = ''
          Adapter device name.
        '';
      };

      full-at = mkOption {
        type = types.str;
        description = ''
          Battery full-at.
        '';
      };
    };
  };

  defaultBattery = {
    type = "internal/battery";

    format-charging = "<animation-charging> <label-charging>";
    format-charging-underline = "#ffb52a";
    label-full = "%percentage%%";
    label-charging = "%percentage%%";

    animation-charging-0 = "";
    animation-charging-1 = "";
    animation-charging-2 = "";
    animation-charging-3 = "";
    animation-charging-4 = "";

    animation-charging-framerate = 750;

    format-discharging = "<animation-discharging> <label-discharging>";
    format-discharging-underline = "\${self.format-charging-underline}";

    label-discharging = "%percentage%%";

    animation-discharging-0 = "";
    animation-discharging-1 = "";
    animation-discharging-2 = "";
    animation-discharging-3 = "";
    animation-discharging-4 = "";

    animation-discharging-framerate = 500;

    format-full-prefix-foreground = "\${colors.foreground-alt}";
    format-full-underline = "\${self.format-charging-underline}";

    ramp-capacity-0 = "";
    ramp-capacity-1 = "";
    ramp-capacity-2 = "";
    ramp-capacity-foreground = "\${colors.foreground-alt}";
  };

  _genDefBat = battery: number: (
    nameValuePair "module/battery-${toString number}" (defaultBattery // battery)
  );

  genDefBat = batteries:
    (imap0
      (i: bat:
        (_genDefBat bat i)
      )
      batteries
    )
  ;
in
{
  options.my.home.polybar = {
    enable = mkEnableOption "polybar configurations";
    wlan = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        wlan interface
      '';
    };
    eth = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        eth interface
      '';
    };
    backlight = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable backlight
      '';
    };
    batteries = mkOption {
      type = types.listOf batteryModule;
      default = [ ];
      description = ''
        All battery devices.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.polybar = {
      enable = true;

      package = pkgs.polybar.override {
        i3Support = true;
        pulseSupport = true;
      };

      settings =
        let
          batteriesPair = (genDefBat cfg.batteries);
          batteriesModules = (listToAttrs batteriesPair);
        in
        {
          "colors" = {
            background = "\${xrdb:background}";
            background-alt = "#444";
            foreground = "\${xrdb:foreground}";
            foreground-alt = "#555";
            primary = "#ffb52a";
            secondary = "#e60053";
            alert = "#bd2c40";
          };

          "global/wm" = {
            margin-top = 5;
            margin-bottom = 5;
          };

          "bar/mybar" = {
            monitor = "\${env:MONITOR:DP-1}";
            width = "100%";
            height = 40;
            radius = 6.0;
            fixed-center = true;

            background = "\${colors.background}";
            foreground = "\${colors.foreground}";

            line-size = 3;
            line-color = "#f00";

            border-size = 1;
            border-color = "\${colors.background}";

            padding-left = 0;
            padding-right = 5;

            module-margin-left = 1;
            module-margin-right = 2;

            font-0 = "San Francisco Display:style=Regular:size=14;4";
            font-1 = "Siji:style=Regular:size=10;4";
            font-2 = "Font Awesome 5 Free Solid:style=Solid:size=10;4";
            font-3 = "Font Awesome 5 Brands:style=Regular:size=10;4";

            modules-left = "i3";
            modules-center = "${(concatMapStrings (bat: (removePrefix "module/" bat.name) + " ") batteriesPair)}${if cfg.backlight then "backlight " else ""}pulseaudio";
            modules-right = "cpu-info memory-info ${if !(isNull cfg.wlan) then "wlan " else ""}${if !(isNull cfg.eth) then "eth " else ""}custom-date xkeyboard";

            tray-position = "right";
            tray-padding = 2;

            cursor-click = "pointer";
            cursor-scroll = "ns-resize";
            enable-ipc = true;
          };

          "module/i3" = {
            type = "internal/i3";
            format = "<label-state> <label-mode>";
            index-sort = true;
            wrapping-scroll = false;

            label-mode-padding = 2;
            label-mode-foreground = "#000";
            label-mode-background = "\${colors.primary}";

            label-focused = "%name%";
            label-focused-background = "\${colors.background-alt}";
            label-focused-underline = "\${colors.primary}";
            label-focused-padding = 4;

            label-unfocused = "%name%";
            label-unfocused-padding = 2;

            label-visible = "%name%";
            label-visible-background = "\${self.label-focused-background}";
            label-visible-underline = "\${self.label-focused-underline}";
            label-visible-padding = "\${self.label-focused-padding}";

            label-urgent = "%name%";
            label-urgent-background = "\${colors.alert}";
            label-urgent-padding = 2;

            strip-wsnumbers = true;
          };

          "module/xkeyboard" = {
            type = "internal/xkeyboard";
            blacklist-0 = "num lock";
            interval = 1;

            format-prefix = "\" \"";
            format-prefix-foreground = "\${colors.foreground-alt}";
            format-prefix-underline = "\${colors.secondary}";

            label-layout = "%layout%";
            label-layout-underline = "\${colors.secondary}";

            label-indicator-padding = 2;
            label-indicator-margin = 1;
            label-indicator-background = "\${colors.secondary}";
            label-indicator-underline = "\${colors.secondary}";
          };

          "module/filesystem" = {
            type = "internal/fs";
            interval = 25;

            mount-0 = "/";

            label-mounted = "%{F#0a81f5}%mountpoint%%{F-}: %percentage_used%%";
            label-unmounted = "%mountpoint% not mounted";
            label-unmounted-foreground = "\${colors.foreground-alt}";
          };

          "module/backlight" = {
            type = "internal/backlight";
            card = "intel_backlight";
            label = " %percentage%%";

            # Available tags:
            #   <label> (default)
            #   <ramp>
            #   <bar>
            format = "<label>";

            # Only applies if <ramp> is used
            ramp-0 = "🌕";
            ramp-1 = "🌔";
            ramp-2 = "🌓";
            ramp-3 = "🌒";
            ramp-4 = "🌑";

            # Only applies if <bar> is used
            bar-width = 10;
            bar-indicator = "|";
            bar-fill = "─";
            bar-empty = "─";
          };

          "module/cpu" = {
            type = "internal/cpu";
            interval = 1;
            format-prefix = "\" \"";
            format-prefix-foreground = "\${colors.foreground}";
            format-underline = "#f90000";
            label = "%percentage:2%%";
          };

          "module/cpu-info" = {
            type = "custom/script";
            interval = 1;
            exec = "~/.scripts/system_status/cpu.sh";
            click-left = "~/.scripts/system_status/cpu.sh --popup";
            format-prefix-foreground = "\${colors.foreground}";
            format-underline = "#f90000";
          };

          "module/memory" = {
            type = "internal/memory";
            interval = 1;
            format-prefix = " ";
            format-prefix-foreground = "\${colors.foreground}";
            format-underline = "#4bffdc";
            label = "%gb_used%";
          };

          "module/memory-info" = {
            type = "custom/script";
            interval = 1;
            exec = "~/.scripts/system_status/memory.sh";
            click-left = "~/.scripts/system_status/memory.sh --popup";
            format-prefix-foreground = "\${colors.foreground}";
            format-underline = "#f90000";
          };

          "module/wlan" = {
            type = "internal/network";
            interface = "${if !(isNull cfg.wlan) then "${cfg.wlan}" else ""}";
            interval = "3.0";

            format-connected = "<label-connected>";
            format-connected-underline = "#9f78e1";
            label-connected = "\"%{A1:nm-connection-editor:} %essid%%{A}\"";

            format-disconnected = "";

            ramp-signal-foreground = "\${colors.foreground}";
          };

          "module/eth" = {
            type = "internal/network";
            interface = "${if !(isNull cfg.eth) then "${cfg.eth}" else ""}";
            interval = "3.0";

            format-connected-underline = "#55aa55";
            format-connected-prefix = " ";
            format-connected-prefix-foreground = "\${colors.foreground-alt}";
            label-connected = "%local_ip%";

            format-disconnected = "";
          };

          "module/custom-date" = {
            type = "internal/date";
            interval = 1;

            date = "  %d.%m.%Y  ";
            date-alt = "";

            time = "%H:%M";
            time-alt = "%H:%M";

            format-prefix-foreground = "\${colors.foreground-alt}";
            format-underline = "#0a6cf5";

            label = "%date%  %time%";
          };

          "module/pulseaudio" = {
            type = "internal/pulseaudio";
            interval = 0.5;

            format-volume = "<label-volume>";
            label-volume = " %percentage%%";
            label-volume-foreground = "\${root.foreground}";

            label-muted = "";
            label-muted-foreground = "\${root.foreground}";

            bar-volume-width = 10;
            bar-volume-foreground-0 = "#55aa55";
            bar-volume-foreground-1 = "#55aa55";
            bar-volume-foreground-2 = "#55aa55";
            bar-volume-foreground-3 = "#55aa55";
            bar-volume-foreground-4 = "#55aa55";
            bar-volume-foreground-5 = "#f5a70a";
            bar-volume-foreground-6 = "#ff5555";
            bar-volume-gradient = false;
            bar-volume-indicator = "|";
            bar-volume-indicator-font = 2;
            bar-volume-fill = "─";
            bar-volume-fill-font = 2;
            bar-volume-empty = "─";
            bar-volume-empty-font = 2;
            bar-volume-empty-foreground = "\${colors.foreground-alt}";
          };
        } // batteriesModules;

      script = '''';
    };
  };
}
