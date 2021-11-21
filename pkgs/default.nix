{ pkgs }:

{
  system-san-francisco-font = pkgs.callPackage ./system-san-francisco-font { };
  san-francisco-display-regular-nerd-font = pkgs.callPackage ./san-francisco-display-regular-nerd-font { };
  san-francisco-font = pkgs.callPackage ./san-francisco-font { };
}
