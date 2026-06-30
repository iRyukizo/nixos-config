{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.less;
in
{
  options.my.home.less = {
    enable = mkEnableOption "Home less configuration" // { default = true; };
    pager = mkEnableOption "Home less as default pager" // { default = true; };
  };

  config = mkIf cfg.enable {
    programs.less = {
      enable = true;
    };

    home.sessionVariables = mkIf cfg.pager {
      PAGER = "less";
      LESS = "-M -R -i --mouse --use-color -Dkr -Dd+b -Ds+246 -Du+C -j5";
      MANPAGER = "less";
      MANROFFOPT = "-c";
    };
  };
}
