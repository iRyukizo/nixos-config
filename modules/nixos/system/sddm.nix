{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  custom-sddm-astronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      Background = "Backgrounds/nix-d-nord-blue.jpg";
      FormPosition = "right";
    };
  }).overrideAttrs (oldAttrs: {
    installPhase = oldAttrs.installPhase + ''
      chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/
      cp ${(pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/OulipianSummer/nixos-pattern-nord-wallpapers/d6334f5b2a83c1072d804fc4750450e18f1a02e4/jpgs/nix-d-nord-blue.jpg";
        sha256 = "0ambkmjcsbmmjl5hji5sq0bm44xd3scg3gxkjzfrl83dp0a5bx7y";
      })} \
      $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/nix-d-nord-blue.jpg
    '';
  });

  cfg = config.my.system.sddm;
in
{
  options.my.system.sddm = {
    enable = mkEnableOption "Basic sddm configuration";
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = [
        custom-sddm-astronaut
      ];
      settings = {
        Theme = {
          Current = "sddm-astronaut-theme";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      custom-sddm-astronaut
      kdePackages.qtsvg
      kdePackages.qtvirtualkeyboard
      kdePackages.qtmultimedia
    ];
  };
}
