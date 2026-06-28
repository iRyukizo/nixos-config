{ lib, pkgs, ... }:

let
  inherit (lib.my) recursiveMerge;

  toImport = [
    "cc"
    "lua"
    "nix"
    "rust"
  ];

  importFunc = name: {
    "${name}" = import (./. + "/${name}.nix") { inherit pkgs; };
  };
in
recursiveMerge (map importFunc toImport)
