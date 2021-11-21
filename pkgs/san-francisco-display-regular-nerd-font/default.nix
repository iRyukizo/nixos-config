{ fetchurl, fetchsvn, lib, stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  version = "20211120";
  pname = "san-francisco-display-regular-nerd-font";
  at = "59cf0dc3660e99e66813665354f787895fb41fe1";
  nerd-font-at = "3a05ea62d38e0cb2e4d0f5b06ad674ce3576a7f8";

  srcs = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/AppleDesignResources/SanFranciscoFont/${at}/SanFranciscoDisplay-Regular.otf";
      name = "SanFranciscoDisplay-Regular.otf";
      sha256 = "0w03gl9pz8wgv3c8dfvka3b5lz89s89wj571xkls12i0m2508l75";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/${nerd-font-at}/font-patcher";
      name = "font-patcher";
      sha256 = "1k8yakfml9dwbw6yh5j9hap7lgbrf964fxlpwydc3940ajyh5nd9";
    })
    (fetchsvn {
      url = "https://github.com/ryanoasis/nerd-fonts/trunk/src/";
      rev = "1410";
      sha256 = "fn37zPQO1Z9Q9o8TsFG67IzI0aHhOW6rvM9PjxVW/Vs=";
    })
  ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  sourcRoot = "./";

  nativeBuildInputs = with pkgs; [
    fontforge
    python3
    tree
  ];

  unpackPhase = ''
    runHook preUnpack

    for _src in $srcs; do
      echo $(basename $(stripHash "$_src"))
      cp -r "$_src" $(stripHash "$_src")
    done

    ls
    mv src-r1410 src

    runHook postUnpack
  '';

  buildPhase = ''
    python3 font-patcher -c SanFranciscoDisplay-Regular.otf
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/
    mv *.otf $out/share/fonts/
  '';

  meta = with lib; {
    description = "SanFranciscoDisplay Nerd Font";
    platforms = platforms.all;
  };
}
