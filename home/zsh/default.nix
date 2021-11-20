{ config, pkgs, ... }:

{
  home.file."${config.home.homeDirectory}/.p10k.zsh".source = ./.p10k.zsh;

  programs.zsh = {
    enable = true;
    plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.1.0";
            sha256 = "vUpBkwowQiSmlB/4ZmPlC8794xi9+1kVaQN5BxNk0Go=";
          };
        }
        {
          name = "zsh-cargo-completion";
          file = "zsh-cargo-completion.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "MenkeTechnologies";
            repo = "zsh-cargo-completion";
            rev = "35a9ca5ff58d228b4a332eb70a31172fc4716b61";
            sha256 = "OAC6wXuZoqVVZITS6ygact/Le4+Ty9sdARh2J3S6d/M=";
          };
        }
      ];

    initExtraFirst = ''
    '';

    initExtra = ''
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      ZSH_HIGHLIGHT_STYLES[arg0]=fg=4,bold
      ZLE_RPROMPT_INDENT=0

      # Set shell in vi mode
      set -o vi
      bindkey -M vicmd "^V" edit-command-lineo

      # programs.zsh.completionInit never called
      autoload -U compinit && compinit

      # Setup manpage color
      export LESS_TERMCAP_mb=$'\e[01;31m';
      export LESS_TERMCAP_md=$'\e[01;38;5;4m';
      export LESS_TERMCAP_me=$'\e[0m';
      export LESS_TERMCAP_se=$'\e[0m';
      export LESS_TERMCAP_so=$'\e[38'5'246m';
      export LESS_TERMCAP_ue=$'\e[0m';
      export LESS_TERMCAP_us=$'\e[04;38;5;14m';
    '';

    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      CLICOLOR = "1";
      TERMINAL = "urxvt";
    };

    history = {
      size = 5000;
      save = 5000;
      share = false;
    };

    shellAliases = {
      color-palette = "for i in {0..255}; do print -Pn \"%K{$i}  %k%F{$i}\${(l:3::0:)i}%f \" \${\${(M)$((i%6)):#3}:+$'\n'}; done";
      gt = "git tag";
      gpt = "git push --follow-tags";
      gprs = "git pull --recurse-submodules";
    };

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "golang"
      ];
    };
  };
}
