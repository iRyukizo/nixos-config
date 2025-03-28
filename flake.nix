{
  description = "Ryuki's NixOS configuration.";

  inputs = {
    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
      ref = "main";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

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

    mac-app-util = {
      type = "github";
      owner = "hraban";
      repo = "mac-app-util";
      ref = "master";
    };
  };

  outputs =
    { self
    , agenix
    , flake-utils
    , home-manager
    , nixpkgs
    , pre-commit-hooks
    , mac-app-util
    , ...
    }@inputs:
    let
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

      overlays = import ./configurations/overlays.nix { inherit self; };

      nixosModules = import ./modules { inherit inputs self home-manager; };

      homeConfigurations = import ./configurations/home.nix { inherit inputs self; };

      nixosConfigurations = import ./configurations/nixos.nix { inherit inputs self; };
    };
}
