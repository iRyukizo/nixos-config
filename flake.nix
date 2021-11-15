{
  description = "Ryuki's NixOS configuration.";

  inputs = {
    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "master";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
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

              home-manager.nixosModule
            ];
          }
        ];
      };
    };
  };
}
