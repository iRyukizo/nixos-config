{ lib, pkgs, packages, git-hooks, system, ... }:

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
    "${name}" = import (./. + "/${name}.nix") { inherit lib pkgs git-hooks system; ryuki = packages; };
  };
in
recursiveMerge (map importFunc toImport)
