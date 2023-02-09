{ lib
, pkgs
}:

pkgs.stdenvNoCC.mkDerivation {
  pname = "spotify-song-getter";
  version = "1.0";

  meta = with lib; {
    description = "Get current track song with its artist.";
    platforms = platforms.linux;
  };

  propagatedBuildInputs = with pkgs; [
    (python39.withPackages (pythonPackages: with pythonPackages; [
      dbus-python
    ]))
  ];

  dontUnpack = true;
  installPhase = "install -Dm755 ${./spotify-get-song.py} $out/bin/spotify-get-song";
}
