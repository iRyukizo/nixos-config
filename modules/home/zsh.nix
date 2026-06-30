{ config, lib, pkgs, ... }:

let
  inherit (lib) literalExpression mkDefault mkEnableOption mkIf mkOption optional types;
  inherit (lib.strings) optionalString;
  cfg = config.my.home.zsh;
in
{
  options.my.home.zsh = {
    enable = mkEnableOption "Zsh home configuration";
    theme = mkOption {
      type = types.enum [ "powerlevel10k" "robbyrussell" ];
      default = "powerlevel10k";
      example = literalExpression ''powerlevel10k'';
    };
    clearerAutosuggest = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Autosuggestion default foreground color is a little bit too bright, can
        overwrite it if needed.
      '';
    };
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
      "${config.home.homeDirectory}/.p10k.zsh" = mkIf (cfg.theme == "powerlevel10k") {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/iRyukizo/dotfiles/a027b42823cb25a8505f10550481022105b7f356/zsh/.p10k.zsh";
          sha256 = "1vaia65fp392pxa1jqgs9vqrcmcplpynfxvai9pq79l11bvri2q5";
        };
      };
    };

    # Mixing zsh and oh-my-zsh plugins does not seem the best thing to do
    programs.zsh = {
      enable = true;
      dotDir = "${config.home.homeDirectory}/.zsh";
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
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
      ] ++ optional (cfg.theme == "powerlevel10k") {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      };

      initContent = optionalString (cfg.theme == "powerlevel10k") ''
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '' + optionalString (cfg.theme == "robbyrussell") ''
        ZSH_THEME_NIX_SHELL_PROMPT_PREFIX=" %{$fg_bold[blue]%}(%B%F{208}"
        ZSH_THEME_NIX_SHELL_PROMPT_SUFFIX="%f%b%{$fg_bold[blue]%})%{$reset_color%}"
        prompt_nix_shell() {
          if [[ ! -z "$IN_NIX_SHELL" ]]; then
            echo "''${ZSH_THEME_NIX_SHELL_PROMPT_PREFIX}''${IN_NIX_SHELL}''${ZSH_THEME_NIX_SHELL_PROMPT_SUFFIX}"
          fi
        }

        ZSH_THEME_DIRENV_PROMPT_PREFIX=" %{$fg_bold[magenta]%}"
        ZSH_THEME_DIRENV_PROMPT_SUFFIX="%{$reset_color%}"
        prompt_direnv() {
          if [ ! -z "$DIRENV_DIR" ]; then
            echo "''${ZSH_THEME_DIRENV_PROMPT_PREFIX}📂''${ZSH_THEME_DIRENV_PROMPT_SUFFIX}"
          fi
        }

        PROMPT="%(?:%{$fg_bold[green]%}%1{➜%}:%{$fg_bold[red]%}%1{➜%}) %{$fg_bold[magenta]%}%(1j.%j .)%{$fg_bold[cyan]%}%c%{$reset_color%}"
        PROMPT+=' $(git_prompt_info)'
        RPROMPT="\$(vi_mode_prompt_info)\$(prompt_nix_shell)\$(prompt_direnv)"

        ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
        ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
        ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
        ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
      '' + optionalString cfg.clearerAutosuggest ''
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=245
      '' + ''
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=4,bold
        ZLE_RPROMPT_INDENT=0

        # Set shell in vi mode
        set -o vi
        bindkey -M vicmd "^V" edit-command-line
      '';

      sessionVariables = {
        CLICOLOR = "1";
        SHELL = "${pkgs.zsh}/bin/zsh";
      };

      history = {
        size = 100000;
        save = 100000;
        extended = true;
        expireDuplicatesFirst = true;
        ignoreDups = true;
        share = true;
      };

      shellAliases = {
        color-palette = "for i in {0..255}; do print -Pn \"%K{$i}  %k%F{$i}\${(l:3::0:)i}%f \" \${\${(M)$((i%6)):#3}:+$'\n'}; done";
        gt = "git tag";
        gpt = "git push --follow-tags";
        gprs = "git pull --recurse-submodules";
        ls = "ls --color=auto";
      };

      autosuggestion.enable = true;
      enableCompletion = true;
      # Doesn't work well with oh-my-zsh, it's better to load it in oh-my-zsh plugins
      # enableSyntaxHighlighting = true;

      oh-my-zsh = {
        theme = optionalString (cfg.theme != "powerlevel10k") cfg.theme;

        enable = true;
        custom = "$HOME/.zsh/custom";
        plugins = [
          "direnv"
          "git"
          "fzf"
          "docker"
          "golang"
          "tmux"
          "zsh-syntax-highlighting"
        ] ++ optional (cfg.theme == "robbyrussell") "vi-mode";
      };
    };
  };
}
