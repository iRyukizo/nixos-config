{ self, ... }:

let
  default-overlays = import "${self}/overlays";

  additional-overlays = {
    lib = _final: _prev: { inherit (self) lib; };

    pkgs = _final: prev: {
      ryuki = prev.recurseIntoAttrs (import "${self}/pkgs" { pkgs = prev; });
    };
  };
in
default-overlays // additional-overlays
