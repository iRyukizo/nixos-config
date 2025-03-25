{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.strings) optionalString;

  cfg = config.my.home.tmux;
  urxvtCfg = config.my.home.urxvt;
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
      aggressiveResize = true;
      terminal = "tmux-256color";
      escapeTime = 0;

      extraConfig = ''
        # Smart pane switching with awareness of vim and fzf
        forward_programs="view|n?vim?|fzf"

        should_forward="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?($forward_programs)(diff)?$'"

        bind -n C-j if-shell "$should_forward" "send-keys C-j" "select-pane -D"
        bind -n C-k if-shell "$should_forward" "send-keys C-k" "select-pane -U"
        bind -n C-\\ if-shell "$should_forward" "send-keys C-\\" "select-pane -l"

        # Don't need to forward but still in case
        # bind -n C-h if-shell "$should_forward" "send-keys C-h" "select-pane -L"
        # bind -n C-l if-shell "$should_forward" "send-keys C-l" "select-pane -R"
      '' + optionalString urxvtCfg.enable ''
        set -as terminal-features ",rxvt*:RGB"
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

        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-dir '${config.xdg.stateHome}/tmux/resurrect'
          '';
        }
      ];
    };
  };
}
