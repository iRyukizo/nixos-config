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
    flake-utils.lib.eachSystem
      [
        flake-utils.lib.system.aarch64-linux
        flake-utils.lib.system.x86_64-linux
        flake-utils.lib.system.aarch64-darwin
      ]
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

        devShells = (import ./shells { inherit (pkgs) lib; inherit pkgs system; }) // {
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
            inherit system;
          });
      }
      )
    //
    {
      templates = import ./templates { inherit (nixpkgs) lib; };

      nixosModules = {
        modules = import ./modules;

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
              own = import ./pkgs { pkgs = super; inherit system; };
            })
          ];
          custom_modules = [
            home-manager.nixosModule
            { nixpkgs.overlays = custom_overlays; }
          ] ++ (nixpkgs.lib.attrValues self.nixosModules);

          buildMachine = name: { system, hardwareModules }: nixpkgs.lib.nixosSystem {
            inherit system;
            modules = custom_modules ++ hardwareModules ++ [ (./. + "/machines/${name}") ];
            specialArgs = {
              inherit inputs;
            };
          };
        in
        nixpkgs.lib.mapAttrs buildMachine {
          millenium = {
            inherit system;
            hardwareModules = [
              inputs.nixos-hardware.nixosModules.common-cpu-intel
              inputs.nixos-hardware.nixosModules.common-pc-laptop
            ];
          };
          arcadia = {
            inherit system;
            hardwareModules = [
              inputs.nixos-hardware.nixosModules.common-cpu-intel
            ];
          };
          dragon = {
            inherit system;
            hardwareModules = [
              inputs.nixos-hardware.nixosModules.common-cpu-intel
            ];
          };
        };
    };
}
