{ pkgs, system, ... }:

{
  system-san-francisco-font = pkgs.callPackage ./system-san-francisco-font { };
  san-francisco-display-regular-nerd-font = pkgs.callPackage ./san-francisco-display-regular-nerd-font { };
  san-francisco-font = pkgs.callPackage ./san-francisco-font { };
  gopkgsite = pkgs.callPackage ./gopkgsite { };
} // (if (system != "aarch64-darwin") then {
  spotify-song-getter = pkgs.callPackage ./spotify-song-getter { };
} else { })
