{ fetchFromGitHub, lib, stdenv, ... }:

stdenv.mkDerivation rec {
  version = "20150611";
  pname = "san-francisco-font";
  at = "59cf0dc3660e99e66813665354f787895fb41fe1";

  src = fetchFromGitHub {
    owner = "AppleDesignResources";
    repo = "SanFranciscoFont";
    rev = "${at}";
    sha256 = "L/J0BbYaYr020D+dwFcflXUmhYQoNwpg1D+gRxDy7jo=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = "./";

  installPhase = ''
    mkdir -p $out/share/fonts/san-francisco-font
    cp source/*.otf $out/share/fonts/san-francisco-font
  '';

  meta = with lib; {
    description = "San Francisco Font by Apple";
    platforms = platforms.all;
  };
}
