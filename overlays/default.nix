let
  files = builtins.readDir ./.;
  overlays = builtins.removeAttrs files [ "default.nix" ];
in
builtins.mapAttrs (name: _: import "${./.}/${name}") overlays
