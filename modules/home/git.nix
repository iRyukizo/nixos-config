{ config, lib, ... }:

let
  inherit (builtins) map;
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.home.git;

  emailCondition = types.submodule {
    options = {
      directory = mkOption {
        type = types.str;
        default = "~";
        description = ''
          Location to use.
        '';
      };

      email = mkOption {
        type = types.str;
        description = ''
          Email to use.
        '';
      };
    };
  };

  makeConditions = emConds: (
    map
      (emCond:
        {
          condition = "gitdir:" + emCond.directory;
          contents = {
            user.email = emCond.email;
          };
        }
      )
      emConds
  );
in
{
  options.my.home.git = {
    enable = mkEnableOption "Home git configuration";
    emailConditions = mkOption {
      type = types.listOf emailCondition;
      default = [ ];
      description = ''
        List of conditions for user.email.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          email = "hugo.moreau@epita.fr";
          name = "Hugo Moreau";
        };
        commit = {
          verbose = true;
          gpgsign = true;
        };
        color = { ui = true; };
        core = {
          editor = "vim";
          pager = "less -iXFR --mouse";
        };
        pager = { branch = false; };
        init = { defaultBranch = "master"; };
        push = { default = "simple"; };
        pull = { rebase = true; };
      };

      includes = [
        {
          condition = "gitdir:~/EPITA/LRDE/";
          contents = {
            user = {
              email = "hmoreau@lrde.epita.fr";
            };
          };
        }
        {
          condition = "gitdir:~/EPITA/ASSISTANTS/";
          contents = {
            init = {
              defaultBranch = "main";
            };
          };
        }
      ] ++ makeConditions cfg.emailConditions;

      ignores = [
        "*.so"
        "*.o"
        "*.a"
        "*.out"
        ".venv/"
        ".clangd/"
        ".cache/"
        "compile_commands.json"
        "Session.vim"
        ".direnv"
        "*~"
        "~.swp"
        ".typos.toml"
        ".luarc.json"
        ".harper_dict.txt"
      ];
    };
  };
}
