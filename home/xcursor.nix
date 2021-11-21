{ pkgs, ... }:

{
  xsession.pointerCursor = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
  };
}
