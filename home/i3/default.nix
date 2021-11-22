{ pkgs, lib, ... }:

let
  inherit (builtins) genList map replaceStrings;
  inherit (lib) toLower listToAttrs mapAttrs' nameValuePair foldl recursiveUpdate;

  renameAttrs = f: mapAttrs' (name: value: nameValuePair (f name) value);
  genAttrs' = values: f: listToAttrs (map f values);
  recursiveMerge = foldl recursiveUpdate { };

  modifier = "Mod4";
  terminal = "i3-sensible-terminal";

  movementKeys = [ "Left" "Down" "Up" "Right" ];
  vimMovementKeys = [ "h" "j" "k" "l" ];

  toVimKeyBindings =
    let
      toVimKeys = replaceStrings movementKeys vimMovementKeys;
    in
    renameAttrs toVimKeys;

  addVimKeyBindings = bindings: bindings // (toVimKeyBindings bindings);
  genMovementBindings = f: addVimKeyBindings (genAttrs' movementKeys f);

  toKeycode = n: if n == 10 then 0 else n;
  createWorkspaceBindings = mapping: command:
    let
      createWorkspaceBinding = num:
        nameValuePair
          "${mapping}+${toString (toKeycode num)}"
          "${command} \$ws${toString num}";
      oneToTen = genList (x: x + 1) 10;
    in
    genAttrs' oneToTen createWorkspaceBinding;

  makeModeBindings = attrs: (addVimKeyBindings attrs) // {
    "Escape" = "mode default";
    "Return" = "mode default";
  };

  makeGapsBindings = mode: {
    "plus" = "gaps ${mode} current plus 5";
    "minus" = "gaps ${mode} current minus 5";
    "0" = "gaps ${mode} current set 0";

    "Shift+plus" = "gaps ${mode} all plus 5";
    "Shift+minus" = "gaps ${mode} all minus 5";
    "Shift+0" = "gaps ${mode} all set 0";

    "Return" = "mode \"$mode_gaps\"";
    "Escape" = "mode default";
  };
in
{
  home.file = {
    ".background-image".source = ./background.png;
    ".lock.png".source = ./lock.png;
    ".scripts/system_status/volumeControl.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        # You can call this script like this:
        # $ ./volumeControl.sh up
        # $ ./volumeControl.sh down
        # $ ./volumeControl.sh mute

        function get_volume {
          amixer -M get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
        }

        function is_mute {
          amixer -M get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
        }

        function send_notification {
          iconSound="audio-volume-high"
          iconMuted="audio-volume-muted"
          if is_mute ; then
            dunstify -t 1000 -i $iconMuted -r 2593 -u normal "mute"
          else
            volume=$(get_volume)
            bar=$(seq --separator="─" 0 "$((volume / 5))" | sed 's/[0-9]//g')
            dunstify -t 1000 -i $iconSound -r 2593 -u normal "$volume%"$'\n'"$bar"
          fi
        }

        case $1 in
        up)
          pamixer --allow-boost -i 5
          send_notification
        ;;
        down)
          pamixer --allow-boost -d 5
          send_notification
        ;;
        mute)
          pamixer --toggle-mute
          send_notification
        ;;
        esac
      '';
    };
    ".scripts/system_status/micControl.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        function is_mic_mute {
          pactl list | sed -n '/^Source/,/^$/p' | grep Mute | grep yes > /dev/null
        }

        function send_notification {
          iconMic="microphone-sensitivity-high-symbolic"
          iconMuted="microphone-sensitivity-muted-symbolic"
          if is_mic_mute ; then
            dunstify -t 1000 -i $iconMuted -r 2593 -u normal "mute"
          else
            dunstify -t 1000 -i $iconMic -r 2593 -u normal  "unmute"
          fi
        }

        case $1 in
        mute)
                pactl set-source-mute @DEFAULT_SOURCE@ toggle
                send_notification
        ;;
        esac
      '';
    };
    ".scripts/system_status/brightnessControl.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        # You can call this script like this:
        # $ ./brightnessControl.sh up
        # $ ./brightnessControl.sh down

        function send_notification {
          icon="notification-display-brightness"
          brightness="$1"
          bar=$(seq -s "─" 0 $((brightness / 5)) | sed 's/[0-9]//g')
          dunstify -t 1000 -i "$icon" -r 5432 -u normal "$brightness%"$'\n'"$bar"
        }

        case $1 in
          up)
            newBrightness=$(brightnessctl -m set "+2%" | cut -d, -f4 | tr -d '%')
            send_notification "$newBrightness"
            ;;
          down)
            newBrightness=$(brightnessctl -m set "2%-" | cut -d, -f4 | tr -d '%')
            send_notification "$newBrightness"
            ;;
        esac
      '';
    };
    ".scripts/system_status/cpu.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env zsh

        case "$1" in
        --popup)
          dunstify -i "" -t 3000 -r 9574 -u normal " CPU time (%)" "$(ps axch -o cmd:10,pcpu k -pcpu | head | awk '$0=$0"%"' )"
          ;;
        *)
          # calculate cpu load (percentage)
          cpu_clock=$(lscpu | grep "CPU MHz:" | awk '{print $3}')
          max_clock=$(lscpu | grep "CPU max MHz:" | awk '{print $4}')
          # replace , in max clock with .
          max_clock="''${max_clock//[,]/.}"
          # calculate clock percentage of max
          clock_percentage="$(( cpu_clock * 100 / max_clock ))"
          # for print, separate int part and floating point digits
          clock_percentage_int=''${clock_percentage%%.*}
          clock_percentage_rat=''${clock_percentage##*.}
          # only display 2 floating digits
          clock_percentage="''${clock_percentage_int}.''${clock_percentage_rat:0:2}"

          # get cpu temperature
          cpu_temp=$(sensors | grep "Package id 0:" | head -1 | awk '{print $4}')
          # remove + and floating point digit
          cpu_temp="''${cpu_temp//+}"
          cpu_temp="''${cpu_temp//.0}"
          echo " $clock_percentage%    $cpu_temp"
          ;;
        esac
      '';
    };
    ".scripts/system_status/memory.sh" = {
      executable = true;
      text = ''
        #!/bin/sh
        case "$1" in
        --popup)
          dunstify -i "" -t 3000 -r 9574 -u normal " Memory (%)" "$(ps axch -o cmd:10,pmem k -pmem | head | awk '$0=$0"%"' )"
        ;;
        *)
          echo " $(free -h --si | awk '/^Mem:/ {print $3 "/" $2}')"
        ;;
        esac
      '';
    };
    ".config/polybar/launch.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh

        # multiple monitors
        if ! pgrep polybar; then
            if type "xrandr"; then
              for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
                MONITOR=$m polybar mybar &
              done
            else
              polybar --reload mybar &
            fi
        else
            pkill polybar
            if type "xrandr"; then
              for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
                MONITOR=$m polybar mybar &
              done
            else
              polybar --reload mybar &
            fi
        fi

        echo "Bars launched..."
      '';
    };
  };

  imports = [
    ./polybar
  ];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      inherit modifier;

      fonts = {
        names = [ "SanFranciscoDisplay Nerd Font" ];
        style = "Regular";
        size = 14.0;
      };

      keybindings = recursiveMerge [
        (
          genMovementBindings (
            key: nameValuePair
              "${modifier}+${key}"
              "focus ${toLower key}"
          )
        )
        (
          genMovementBindings (
            key: nameValuePair
              "${modifier}+Shift+${key}"
              "move ${toLower key}"
          )
        )
        (
          genMovementBindings (
            key: nameValuePair
              "${modifier}+Shift+${key}"
              "move ${toLower key} 10 px"
          )
        )
        {
          "${modifier}+b" = "split h; exec dunstify -t 1000 'tile horizontally'";
          "${modifier}+v" = "split v; exec dunstify -t 1000 'tile vertically'";
        }
        {
          "${modifier}+q" = "focus parent";
          "${modifier}+a" = "focus child";
        }
        {
          "${modifier}+s" = "layout stacking";
          "${modifier}+z" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
        }
        {
          "${modifier}+Shift+Q" = "kill";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+e" = "exec \"i3-nagbar -t warning -m 'Do you want to exit i3?' -B 'Yes, exit i3' 'i3-msg exit'\"";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+i" = ''exec --no-startup-id "pkill -u $USER -USR1 dunst; betterlockscreen --lock; pkill -u $USER -USR2 dunst"'';
        }
        {
          "${modifier}+d" = "exec rofi -show run";
          "${modifier}+c" = "exec rofi -show calc";
        }
        {
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+r" = "mode resize";
          "${modifier}+Shift+g" = "mode \"$mode_gaps\"";
        }
        {
          "${modifier}+Shift+f" = "exec firefox";
        }
        {
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
        }
        {
          "XF86AudioRaiseVolume" = "exec ~/.scripts/system_status/volumeControl.sh up";
          "XF86AudioLowerVolume" = "exec ~/.scripts/system_status/volumeControl.sh down";
          "XF86AudioMute" = "exec ~/.scripts/system_status/volumeControl.sh mute";
          "XF86AudioMicMute" = "exec ~/.scripts/system_status/micControl.sh mute";
        }
        {
          "XF86MonBrightnessUp" = "exec ~/.scripts/system_status/brightnessControl.sh up";
          "XF86MonBrightnessDown" = "exec ~/.scripts/system_status/brightnessControl.sh down";
        }
        (createWorkspaceBindings modifier "workspace number")
        (createWorkspaceBindings "${modifier}+Shift" "move container to workspace number")
      ];

      window = {
        hideEdgeBorders = "none";
      };

      gaps = {
        smartBorders = "on";
        inner = 10;
        outer = 0;
      };

      colors = {
        focused = {
          border = "$bg-color";
          background = "$bg-color";
          text = "$text-color";
          indicator = "$indicator";
          childBorder = "$bg-color";
        };

        unfocused = {
          border = "$inactive-bg-color";
          background = "$inactive-bg-color";
          text = "$inactive-text-color";
          indicator = "$indicator";
          childBorder = "$bg-color";
        };

        focusedInactive = {
          border = "$inactive-bg-color";
          background = "$inactive-bg-color";
          text = "$inactive-text-color";
          indicator = "$indicator";
          childBorder = "$bg-color";
        };

        urgent = {
          border = "$urgent-bg-color";
          background = "$urgent-bg-color";
          text = "$text-color";
          indicator = "$indicator";
          childBorder = "$bg-color";
        };
      };

      focus = { };

      bars = [ ];

      modes = {
        resize = (makeModeBindings {
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";

          "Shift+Left" = "resize shrink width 1 px or 1 ppt";
          "Shift+Down" = "resize grow height 1 px or 1 ppt";
          "Shift+Up" = "resize shrink height 1 px or 1 ppt";
          "Shift+Right" = "resize grow width 1 px or 1 ppt";
        }) // { "${modifier}+r" = "mode default"; };

        "$mode_gaps" = {
          "o" = "mode \"$mode_gaps_outer\"";
          "i" = "mode \"$mode_gaps_inner\"";
          "h" = "mode \"$mode_gaps_horiz\"";
          "v" = "mode \"$mode_gaps_verti\"";
          "t" = "mode \"$mode_gaps_top\"";
          "r" = "mode \"$mode_gaps_right\"";
          "b" = "mode \"$mode_gaps_bottom\"";
          "l" = "mode \"$mode_gaps_left\"";
          "Return" = "mode default";
          "Escape" = "mode default";
          "${modifier}+g" = "mode default";
        };

        "$mode_gaps_outer" = makeGapsBindings "outer";
        "$mode_gaps_inner" = makeGapsBindings "inner";
        "$mode_gaps_horiz" = makeGapsBindings "horizontal";
        "$mode_gaps_verti" = makeGapsBindings "veritcal";
        "$mode_gaps_top" = makeGapsBindings "top";
        "$mode_gaps_bottom" = makeGapsBindings "bottom";
        "$mode_gaps_left" = makeGapsBindings "left";
        "$mode_gaps_right" = makeGapsBindings "right";
      };

      assigns = {
        "$ws4" = [{ class = "Thunderbird"; }];
        "$ws5" = [{ class = "discord"; }];
      };
    };

    extraConfig = ''
      bindsym --release ${modifier}+Shift+s exec scrot -s 'screenshot_%Y%m%d_%H%M%S.png' -e 'mkdir -p ~/Pictures/screenshots && mv $f ~/Pictures/screenshots && xclip -selection clipboard -t image/png -i ~/Pictures/screenshots/`ls -1 -t ~/Pictures/screenshots | head -1`' # Area selection

      exec_always --no-startup-id $HOME/.config/polybar/launch.sh

      set $bg-color            #2f343f
      set $inactive-bg-color   #2f343f
      set $text-color          #f3f4f5
      set $inactive-text-color #676E7D
      set $urgent-bg-color     #E53935
      set $indicator           #00ff00

      set $ws1 "1:"
      set $ws2 "2:"
      set $ws3 "3"
      set $ws4 "4:"
      set $ws5 "5:"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10:"

      new_window pixel 1
      new_float normal

      set $mode_gaps Gaps: (o)uter, (i)nner, (h)orizontal, (v)ertical, (t)op, (r)ight, (b)ottom, (l)eft
      set $mode_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
      set $mode_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)
      set $mode_gaps_horiz Horizontal Gaps: +|-|0 (local), Shift + +|-|0 (global)
      set $mode_gaps_verti Vertical Gaps: +|-|0 (local), Shift + +|-|0 (global)
      set $mode_gaps_top Top Gaps: +|-|0 (local), Shift + +|-|0 (global)
      set $mode_gaps_right Right Gaps: +|-|0 (local), Shift + +|-|0 (global)
      set $mode_gaps_bottom Bottom Gaps: +|-|0 (local), Shift + +|-|0 (global)
      set $mode_gaps_left Left Gaps: +|-|0 (local), Shift + +|-|0 (global)
    '';
  };
}
