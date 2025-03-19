{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf optional;
  inherit (lib.strings) optionalString;
  cfg = config.my.home.zsh;
in
{
  options.my.home.zsh = {
    enable = mkEnableOption "Zsh home configuration";
    p10k = mkEnableOption "Zsh P10K prompt" // { default = true; };
  };

  config = mkIf cfg.enable {
    my.home = {
      fonts.enable = mkDefault true;
      ranger.enable = mkDefault true;
    };

    home.file = {
      "${config.home.homeDirectory}/.zsh/custom/plugins/zsh-syntax-highlighting".source = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "c7caf57ca805abd54f11f756fda6395dd4187f8a";
        sha256 = "MeuPqDeJpbJi2hT7VUgyQNSmDPY/biUncvyY78IBfzM=";
      };
      "${config.home.homeDirectory}/.p10k.zsh" = mkIf cfg.p10k {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/iRyukizo/dotfiles/a027b42823cb25a8505f10550481022105b7f356/zsh/.p10k.zsh";
          sha256 = "1vaia65fp392pxa1jqgs9vqrcmcplpynfxvai9pq79l11bvri2q5";
        };
      };
    };

    # Mixing zsh and oh-my-zsh plugins does not seem the best thing to do
    programs.zsh = {
      enable = true;
      plugins = [
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
      ] ++ optional (cfg.p10k) {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      };

      initExtraFirst = ''
      '';

      initExtra = optionalString cfg.p10k ''
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '' + ''
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=4,bold
        ZLE_RPROMPT_INDENT=0

        # Set shell in vi mode
        set -o vi
        bindkey -M vicmd "^V" edit-command-line

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
        MANPAGER = "less --mouse";
        PAGER = "less --mouse";
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

      autosuggestion.enable = true;
      enableCompletion = true;
      # Doesn't work well with oh-my-zsh, it's better to load it in oh-my-zsh plugins
      # enableSyntaxHighlighting = true;

      oh-my-zsh = {
        enable = true;
        custom = "$HOME/.zsh/custom";
        plugins = [
          "git"
          "docker"
          "golang"
          "tmux"
          "zsh-syntax-highlighting"
        ];
      };
    };
  };
}
