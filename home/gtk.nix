{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.gtk;
in
{
  options.my.home.gtk = {
    enable = mkEnableOption "Home gtk configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      arc-theme
      cantarell-fonts
      gnome.adwaita-icon-theme
      papirus-icon-theme
    ];

    home.pointerCursor = {
      x11.enable = true;
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    gtk = {
      enable = true;
      font = {
        package = pkgs.cantarell-fonts;
        name = "Cantarell";
        size = 11;
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };
      gtk2 = {
        extraConfig = ''
          gtk-cursor-theme-name="Adwaita"
          gtk-cursor-theme-size=24
          gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
          gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
          gtk-button-images=0
          gtk-menu-images=0
        '';
      };
      gtk3 = {
        extraConfig = {
          gtk-cursor-theme-name = "Adwaita";
          gtk-cursor-theme-size = 32;
        };
        bookmarks = [
          "file://${config.home.homeDirectory}/Downloads"
          "file://${config.home.homeDirectory}/EPITA"
          "file://${config.home.homeDirectory}/Pictures/screenshots"
        ];
      };
    };
  };
}
