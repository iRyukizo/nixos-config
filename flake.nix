{
  description = "Ryuki's NixOS configuration.";

  inputs = {
    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "master";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations =
    let
      system = "x86_64-linux";
    in
    {
      SaturnV = nixpkgs.lib.nixosSystem rec {
        inherit system;
        modules = [
          {
            imports = [
              ./machines/SaturnV
            ];
          }
        ];
      };
    };
  };
}
