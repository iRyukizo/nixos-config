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

    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    pre-commit-hooks = {
      type = "github";
      owner = "cachix";
      repo = "pre-commit-hooks.nix";
      ref = "master";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    { self
    , flake-utils
    , home-manager
    , nixpkgs
    , pre-commit-hooks
    , ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
      {
        checks = {
          pre-commit = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks.nixpkgs-fmt.enable = true;
          };
        };
      }
      )
    //
    {
      nixosModules = {
        home = {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            verbose = true;
            users = {
              ryuki = import ./home;
            };
          };
        };
      };

      nixosConfigurations =
        let
          system = "x86_64-linux";
        in
        {
          millenium = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              {
                imports = [
                  ./machines/millenium

                  home-manager.nixosModule
                ] ++ (nixpkgs.lib.attrValues self.nixosModules);
              }
            ];
          };
        };
    };
}
