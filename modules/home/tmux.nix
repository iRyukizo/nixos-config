{ config, lib, pkgs, ... }:

let
  inherit (lib) literalExpression mkEnableOption mkIf mkOption types;
  inherit (lib.strings) optionalString;

  cfg = config.my.home.tmux;
  urxvtCfg = config.my.home.terminal.urxvt;
  alacrittyCfg = config.my.home.terminal.alacritty;
in
{
  options.my.home.tmux = {
    enable = mkEnableOption "Home tmux configuration";
    type = mkOption {
      type = types.enum [ "standard" "darwin" "remote" "wsl" ];
      default = "standard";
      example = literalExpression ''standard'';
      description = ''
        Type of system (default: standard).
        Options: standard darwin remote wsl
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      keyMode = "vi";
      customPaneNavigationAndResize = true;
      mouse = false;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      aggressiveResize = true;
      terminal = if (cfg.type == "darwin") then "xterm-256color" else "tmux-256color";
      escapeTime = 0;

      extraConfig = ''
        # Vim binding for copy mode
        bind-key -T copy-mode-vi v send -X begin-selection
        bind-key -T copy-mode-vi C-v send -X rectangle-toggle
        ${optionalString (cfg.type != "standard") "bind-key -T copy-mode-vi y send -X copy-selection-and-cancel"}

        set -g set-clipboard on

        # Smart pane switching with awareness of vim and fzf
        forward_programs="view|n?vim?|fzf|\.vim-wrapped"

        should_forward="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?($forward_programs)(diff)?$'"

        bind -n C-j if-shell "$should_forward" "send-keys C-j" "select-pane -D"
        bind -n C-k if-shell "$should_forward" "send-keys C-k" "select-pane -U"
        bind -n C-\\ if-shell "$should_forward" "send-keys C-\\" "select-pane -l"

        # Don't need to forward but still in case
        # bind -n C-h if-shell "$should_forward" "send-keys C-h" "select-pane -L"
        # bind -n C-l if-shell "$should_forward" "send-keys C-l" "select-pane -R"

        bind-key -r M-h resize-pane -L 5
        bind-key -r M-j resize-pane -D 5
        bind-key -r M-k resize-pane -U 5
        bind-key -r M-l resize-pane -R 5
      '' + optionalString urxvtCfg.enable ''
        set -as terminal-features ",rxvt*:RGB"
      '' + optionalString alacrittyCfg.enable ''
        set -as terminal-features ",alacritty:RGB"
      '' + optionalString (cfg.type == "darwin") ''
        set -as terminal-features ",xterm-256color:RGB"
        # Can't set default shell as home-manager is not system level
        set -g default-command ${pkgs.zsh}/bin/zsh
      '' + optionalString (cfg.type == "wsl") ''
        set -g default-command ${pkgs.zsh}/bin/zsh
      '';

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = nord;
          extraConfig = optionalString (cfg.type == "wsl") ''
            set -g @prefix_highlight_fg black
            set -g @prefix_highlight_bg brightcyan
            set -g status-interval 1
            set -g status on
            set -g status-justify left
            set -g status-style bg=black,fg=white
            set -g pane-border-style bg=default,fg=brightblack
            set -g pane-active-border-style bg=default,fg=blue
            set -g display-panes-colour black
            set -g display-panes-active-colour brightblack
            setw -g clock-mode-colour cyan
            set -g message-style bg=brightblack,fg=cyan
            set -g message-command-style bg=brightblack,fg=cyan
            set -g @prefix_highlight_output_prefix "#[fg=brightcyan]#[bg=black]#[nobold]#[noitalics]#[nounderscore]#[bg=brightcyan]#[fg=black]"
            set -g @prefix_highlight_output_suffix ""
            set -g @prefix_highlight_copy_mode_attr "fg=brightcyan,bg=black,bold"
            set -g status-left "#[fg=black,bg=blue,bold] #S #[fg=blue,bg=black,nobold,noitalics,nounderscore]"
            set -g window-status-format "#[fg=black,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#I #[fg=white,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#W #F #[fg=brightblack,bg=black,nobold,noitalics,nounderscore]"
            set -g window-status-current-format "#[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#I #[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#W #F #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
            set -g window-status-separator ""
          '' + ''
            set -g status-position top
          '';
        }
        {
          plugin = prefix-highlight;
          # Little workaround cause plugin are loaded after internal extraConfig but before general extraConfig.
          # We need to run the plugin after the extraConfig is loaded.
          # Thus setting up here.
          extraConfig = ''
            # Little fix because for some reason on some distros, the message are not filled by default
            set -g message-style bg=brightblack,fg=cyan,fill=brightblack
            set -g message-command-style bg=brightblack,fg=cyan,fill=brightblack

            set -g status-right-length "60"
            set -g status-right "#{prefix_highlight}#[fg=yellow,bg=black,nobold,noitalics,nounderscore]#[fg=black,bg=yellow] #{cpu_icon} #{cpu_percentage} #[fg=brightblack,bg=yellow,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %I:%M %p #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan,bold] #H "

            # tmuxplugin-prefix-highlight
            set -g @prefix_highlight_show_copy_mode 'on'
            set -g @prefix_highlight_prefix_prompt " Prefix "
            set -g @prefix_highlight_copy_prompt " Copy "
          '';
        }

        pain-control
        cpu
        {
          plugin = vim-tmux-navigator;
          extraConfig = ''
            bind C-l send-keys 'C-l'
          '';
        }

        {
          plugin = yank;
          extraConfig = ''
            set -g @yank_selection_mouse 'clipboard'
          '';
        }

        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-processes '~vim'

            set -g @resurrect-dir '${config.xdg.stateHome}/tmux/resurrect'
          '';
        }
      ];
    };
  };
}
