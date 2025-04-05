{ config, pkgs, lib, ... }:

let
  inherit (builtins) genList map replaceStrings;
  inherit (lib) literalExpression mkOption mkEnableOption mkIf nameValuePair types;
  inherit (lib.my) genAttrs' recursiveMerge renameAttrs;

  cfg = config.my.home.aerospace;

  movementKeys = [ "left" "down" "up" "right" ];
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
          "${mapping}-${toString (toKeycode num)}"
          "${command} ${toString num}";
      oneToTen = genList (x: x + 1) 10;
    in
    genAttrs' oneToTen createWorkspaceBinding;

  makeModeBindings = attrs: (addVimKeyBindings attrs) // {
    "enter" = "mode main";
    "esc" = "mode main";
  };
in
{
  options.my.home.aerospace = {
    enable = mkEnableOption "Aerospace home configuration";
    terminal = mkOption {
      type = types.str;
      default = "alacritty";
      example = literalExpression "alacritty";
    };
    modifier = mkOption {
      type = types.enum [ "cmd" "alt" "ctrl" "shift" ];
      default = "alt";
      example = literalExpression "cmd";
      description = ''
        Modifier key (deault: 'alt')
        Options: cmd alt ctrl shift
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.aerospace = {
      enable = true;

      userSettings = {
        enable-normalization-flatten-containers = false;
        enable-normalization-opposite-orientation-for-nested-containers = false;
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
        on-focus-changed = [ "move-mouse window-lazy-center" ];
        accordion-padding = 30;

        workspace-to-monitor-force-assignment = {
          "9" = "2";
          "10" = "2";
        };

        gaps = {
          inner.horizontal = 10;
          inner.vertical = 10;
          outer.left = 10;
          outer.bottom = 10;
          outer.top = 10;
          outer.right = 10;
        };

        mode.main.binding = recursiveMerge [
          (genMovementBindings (key: nameValuePair "${cfg.modifier}-${key}" "focus --boundaries-action wrap-around-the-workspace ${key}"))
          (genMovementBindings (key: nameValuePair "${cfg.modifier}-shift-${key}" "move ${key}"))
          (createWorkspaceBindings cfg.modifier "workspace")
          (createWorkspaceBindings "${cfg.modifier}-shift" "move-node-to-workspace")

          {
            "${cfg.modifier}-b" = "split horizontal";
            "${cfg.modifier}-v" = "split vertical";

            "${cfg.modifier}-minus" = "resize smart -50";
            "${cfg.modifier}-equal" = "resize smart +50";

            "${cfg.modifier}-s" = "layout v_accordion"; # "layout stacking"
            "${cfg.modifier}-z" = "layout h_accordion"; # "layout tabbed"
            "${cfg.modifier}-e" = "layout tiles horizontal vertical"; # "layout toggle split"

            "${cfg.modifier}-shift-q" = "close"; # Use alt-w or command-q directly
            "${cfg.modifier}-f" = "fullscreen";
            "${cfg.modifier}-shift-f" = "macos-native-fullscreen";
            "${cfg.modifier}-enter" = ''exec-and-forget open -na ${cfg.terminal}'';
            "${cfg.modifier}-shift-c" = "reload-config";

            "${cfg.modifier}-shift-space" = "layout floating tiling"; # "floating toggle"
            "${cfg.modifier}-r" = "mode resize";
          }
        ];

        mode.resize.binding = (makeModeBindings {
          "left" = "resize width -50";
          "down" = "resize height +50";
          "up" = "resize height -50";
          "right" = "resize width +50";

          "shift-left" = "resize width -10";
          "shift-down" = "resize height +10";
          "shift-up" = "resize height -10";
          "shift-right" = "resize width +10";
        }) // {
          "0" = "balance-sizes";
        };

      };
    };
  };
}
