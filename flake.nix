{
  description = "Ryuki's NixOS configuration.";

  inputs = {
    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "main";
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

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
      ref = "master";
    };

    pre-commit-hooks = {
      type = "github";
      owner = "cachix";
      repo = "pre-commit-hooks.nix";
      ref = "master";
      inputs = {
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
    let
      custom_overlays = system: [
        (import ./overlays)
        (self: super: {
          own = import ./pkgs { pkgs = super; inherit system; };
        })
      ];
      inherit (flake-utils.lib) eachDefaultSystem flattenTree;
      inherit (nixpkgs.lib) recursiveUpdate;
    in
    eachDefaultSystem
      (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        checks = {
          pre-commit = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks.nixpkgs-fmt.enable = true;
          };
        };

        devShells = (import ./shells { inherit (self) lib; inherit pkgs; }) // {
          default = pkgs.mkShell {
            name = "NixOS-config-devShell";
            nativeBuildInputs = with pkgs; [
              nix-prefetch-github
              nixpkgs-fmt
            ];
          };
        };

        formatter = pkgs.nixpkgs-fmt;

        packages = flattenTree
          (import ./pkgs {
            pkgs = import nixpkgs { inherit system; };
          });
      }
      ) //
    {
      lib = nixpkgs.lib.extend (final: _: recursiveUpdate
        {
          my = import ./lib { inherit inputs; pkgs = nixpkgs; lib = final; };
        }
        (eachDefaultSystem (system: {
          my = import ./pkgs/lib { pkgs = import nixpkgs { inherit system; } // self.packages.${system}; };
        })));

      templates = import ./templates { inherit (self) lib; };

      nixosModules = import ./modules { inherit inputs self home-manager; };

      homeConfigurations = import ./configurations/home.nix { inherit inputs self custom_overlays; };

      nixosConfigurations = import ./configurations/nixos.nix { inherit inputs self custom_overlays; };
    };
}
