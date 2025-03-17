{ fetchurl, fetchzip, lib, stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  version = "20211120";
  pname = "san-francisco-display-regular-nerd-font";
  at = "59cf0dc3660e99e66813665354f787895fb41fe1";
  nerd-font-version = "v3.3.0";

  srcs = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/AppleDesignResources/SanFranciscoFont/${at}/SanFranciscoDisplay-Regular.otf";
      name = "SanFranciscoDisplay-Regular.otf";
      sha256 = "0w03gl9pz8wgv3c8dfvka3b5lz89s89wj571xkls12i0m2508l75";
    })
    (fetchzip {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/${nerd-font-version}/FontPatcher.zip";
      name = "FontPatcher.zip";
      sha256 = "/LbO8+ZPLFIUjtZHeyh6bQuplqRfR6SZRu9qPfVZ0Mw=";
      stripRoot = false;
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

    cp -r FontPatcher.zip/bin bin
    cp -r FontPatcher.zip/src src
    cp FontPatcher.zip/font-patcher font-patcher

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
