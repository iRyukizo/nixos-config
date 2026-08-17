{ lib, pkgs, packages, ... }:

let
  inherit (lib.my) recursiveMerge;

  toImport = [
    "cc"
    "lua"
    "nix"
    "rust"
    "stm32"
    "xc8"
  ];

  importFunc = name: {
    "${name}" = import (./. + "/${name}.nix") { inherit lib pkgs; ryuki = packages; };
  };
in
recursiveMerge (map importFunc toImport)
