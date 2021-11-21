{ ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
      XDG_PERSO_DIR = "$HOME/PERSO";
      XDG_EPITA_DIR = "$HOME/EPITA";
      XDG_ASSIST_DIR = "$HOME/EPITA/ASSISTANTS";
      XDG_LRDE_DIR = "$HOME/EPITA/LRDE";
      XDG_SCROT_DIR = "$HOME/Pictures/screenshots";
    };
  };
}
