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
    ".scripts/system_status/volumeControl.sh".source = ./scripts/system_status/volumeControl.sh;
    ".scripts/system_status/micControl.sh".source = ./scripts/system_status/micControl.sh;
    ".scripts/system_status/brightnessControl.sh".source = ./scripts/system_status/brightnessControl.sh;
    ".scripts/system_status/cpu.sh".source = ./scripts/system_status/cpu.sh;
    ".scripts/system_status/memory.sh".source = ./scripts/system_status/memory.sh;
    ".config/polybar/launch.sh".source = ./polybar/launch.sh;
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
          "${modifier}+i" = "exec --no-startup-id betterlockscreen --lock";
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
