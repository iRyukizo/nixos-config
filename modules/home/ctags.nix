{ config, lib, pkgs, ... }:

let
  inherit (lib)
    literalExpresion
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    types;

  inherit (lib.strings)
    concatStringsSep;

  cfg = config.my.home.ctags;
in
{
  options.my.home.ctags = {
    enable = mkEnableOption "Home ctags configuration";
    package = mkPackageOption pkgs "universal-ctags" { };
    gtags = {
      enable = mkEnableOption "Home ctags with gtags support" // { default = true; };
    };

    settings = {
      recurse = mkEnableOption "ctags --recurse options" // { default = true; };
      excludes = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The regexp file/directory to exclude. (Different from defaultExcludes)
        '';
        example = literalExpresion ''[ "*.swp" "*_generated_*" "build" ]'';
      };
    };

    extraSettings = mkOption {
      type = types.str;
      default = '''';
      description = "Extra settings";
      example = literalExpresion ''
        --sort
        --maxdepth 4
      '';
    };

    defaultExcludes = mkOption {
      type = types.listOf types.str;
      default = [
        ".git"
        ".svn"
        "build"
        "dist"
        "debug"
        "*.js"
        "vendor/*"
        "db/*"
        "log/*"
        "node_modules/*"
        "*.vim"
        "*.swp"
        "*.min.*"
        "*.bak"
        "*.pyc"
        "*.sln"
        "*.class"
        "*.csproj"
        "*.cache"
        "*.dll"
        "*.pdb"
      ];
      description = ''
        The default files and directories to ignore for every ctags.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ] ++ optional cfg.gtags.enable pkgs.global;

    home.file.".ctags.d/default.ctags".text = ''
      # Settings
      --recurse=${if cfg.settings.recurse then "yes" else "no"}
      ${concatStringsSep "\n" (
          map (str: "--exclude=${str}") cfg.settings.excludes
        )}

      # Default excludes
      ${concatStringsSep "\n" (
          map (str: "--exclude=${str}") cfg.defaultExcludes
        )}

      # Extra settings
      ${cfg.extraSettings}
    '';

    home.file.".ctags.d/c.ctags".text = ''
      --languages=+C
      --C-kinds=+plx
    '';
  };
}
