{ pkgs, ... }:

with pkgs;

{
  lichess-bot = callPackage ./lichess-bot { };
  noto-fonts-cjk-sans-tc = callPackage ./noto-fonts-cjk-sans-tc { };
  system-san-francisco-font = callPackage ./system-san-francisco-font { };
  san-francisco-display-regular-nerd-font = callPackage ./san-francisco-display-regular-nerd-font { };
  san-francisco-font = callPackage ./san-francisco-font { };
  microchip-xc8 = callPackage ./microchip-xc8 { };
} // lib.optionalAttrs (!stdenv.isDarwin) {
  spotify-song-getter = callPackage ./spotify-song-getter { };
}
