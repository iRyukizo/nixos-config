{ pkgs, ... }:

with pkgs;

{
  lichess-bot = callPackage ./lichess-bot { };
  system-san-francisco-font = callPackage ./system-san-francisco-font { };
  san-francisco-display-regular-nerd-font = callPackage ./san-francisco-display-regular-nerd-font { };
  san-francisco-font = callPackage ./san-francisco-font { };
  gopkgsite = callPackage ./gopkgsite { };
} // lib.optionalAttrs (!stdenv.isDarwin) {
  spotify-song-getter = callPackage ./spotify-song-getter { };
}
