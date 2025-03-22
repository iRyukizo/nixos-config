{ lib, ... }:

let
  inherit (builtins) map;
  inherit (lib.my) recursiveMerge;

  toImport = [
    "go"
  ];

  templateFunc = name: {
    "${name}" = {
      description = "${name} development basics";
      path = ./. + "/${name}";
    };
  };
in
recursiveMerge (map templateFunc toImport)
