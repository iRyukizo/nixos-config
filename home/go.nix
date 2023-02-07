{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.go;
in
{
  options.my.home.go = {
    enable = mkEnableOption "Home go configuration";
  };

  config = mkIf cfg.enable {
    programs.go = {
      enable = true;
      goPath = "go";
      goBin = "go/bin";
    };

    home.sessionPath = [
      # Some packages are not packaged in go, so old `go install pkgs@version` makes it
      "$HOME/go/bin"
    ];
  };
}
