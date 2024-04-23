{ lib, pkgs, ... }:

let
  inherit (builtins) map;
  inherit (lib) foldl recursiveUpdate;

  recursiveMerge = foldl recursiveUpdate { };

  toImport = [
    "cc"
  ];

  importFunc = name: {
    "${name}" = import (./. + "/${name}.nix") { inherit pkgs; };
  };
in
recursiveMerge (map importFunc toImport)
