{ config, pkgs, ... }:

{
  home.file."${config.home.homeDirectory}/.config/ranger/plugins/ranger_devicons".source = pkgs.fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = "ranger_devicons";
    rev = "11941619b853e9608a41028ac8ebde2e6ca7d934";
    sha256 = "7SOORq7C2PdB5ukkIeH1KGY9AKT9V4GekQQ9KGSp1ek=";
  };

  home.file."${config.home.homeDirectory}/.config/ranger/rc.conf".text = ''
    default_linemode devicons
  '';

  home.file."${config.home.homeDirectory}/.config/ranger/scope.sh".source = pkgs.ranger + "/share/doc/ranger/config/scope.sh";
}
