{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.tmux;
in
{
  options.my.home.tmux = {
    enable = mkEnableOption "Home tmux configuration";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      keyMode = "vi";
      customPaneNavigationAndResize = true;
      mouse = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      terminal = "screen-256color";

      extraConfig = ''
      '';

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = nord;
          extraConfig = ''
            set -g status-position top
          '';
        }
        {
          plugin = prefix-highlight;
          # Little workaround cause plugin are loaded after internal extraConfig but before general extraConfig.
          # We need to run the plugin after the extraConfig is loaded.
          # Thus setting up here.
          extraConfig = ''
            set -g status-right-length "60"
            set -g status-right "#{prefix_highlight}#[fg=yellow,bg=black,nobold,noitalics,nounderscore]#[fg=black,bg=yellow] #{cpu_icon} #{cpu_percentage} #[fg=brightblack,bg=yellow,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %I:%M %p #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan,bold] #H "

            # tmuxplugin-prefix-highlight
            set -g @prefix_highlight_show_copy_mode 'on'
            set -g @prefix_highlight_prefix_prompt " Prefix "
            set -g @prefix_highlight_copy_prompt " Copy "
          '';
        }

        cpu
        {
          plugin = vim-tmux-navigator;
          extraConfig = ''
            bind C-l send-keys 'C-l'
          '';
        }
      ];
    };
  };
}
