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
      let
        inherit (inputs.flake-utils.lib) flattenTree;
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        checks = {
          pre-commit = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks.nixpkgs-fmt.enable = true;
          };
        };

        devShell = pkgs.mkShell {
          name = "NixOS-config-devShell";
          nativeBuildInputs = with pkgs; [
            nix-prefetch-github
            nixpkgs-fmt
          ];
        };

        packages = flattenTree
          (import ./pkgs {
            pkgs = import nixpkgs { inherit system; };
          });
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
          custom_overlays = [
            (self: super: {
              own = import ./pkgs { pkgs = super; };
            })
          ];
          custom_modules = [
            home-manager.nixosModule
            { nixpkgs.overlays = custom_overlays; }
          ] ++ (nixpkgs.lib.attrValues self.nixosModules);
        in
        {
          millenium = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              {
                imports = [
                  ./machines/millenium.nix

                  inputs.nixos-hardware.nixosModules.common-cpu-intel
                  inputs.nixos-hardware.nixosModules.common-pc-laptop
                ] ++ custom_modules;
              }
            ];
          };

          arcadia = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              {
                imports = [
                  ./machines/arcadia.nix

                  inputs.nixos-hardware.nixosModules.common-cpu-intel
                ] ++ custom_modules;
              }
            ];
          };

          dragon = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              {
                imports = [
                  ./machines/dragon.nix

                  inputs.nixos-hardware.nixosModules.common-cpu-intel
                ] ++ custom_modules;
              }
            ];
          };

          mothership = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              {
                imports = [
                  ./machines/mothership.nix

                  inputs.nixos-hardware.nixosModules.common-cpu-intel

                  { nixpkgs.overlays = custom_overlays; }
                ];
              }
            ];
          };
        };
    };
}
