{ pkgs, ... }:

{
  home.pointerCursor = {
    x11.enable = true;
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
  };
}
