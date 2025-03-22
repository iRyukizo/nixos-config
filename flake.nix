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
      inherit (flake-utils.lib) eachDefaultSystem;
      inherit (nixpkgs.lib) recursiveUpdate;
    in
    recursiveUpdate
    (eachDefaultSystem
      (system:
      let
        inherit (inputs.flake-utils.lib) flattenTree;
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

        packages = flake-utils.lib.flattenTree
          (import ./pkgs {
            pkgs = import nixpkgs { inherit system; };
          });
      }
      ))
    {
      lib = nixpkgs.lib.extend (final: _: recursiveUpdate {
        my = import ./lib { inherit inputs; pkgs = nixpkgs; lib = final; };
      } (eachDefaultSystem (system: {
        my = import ./pkgs/lib { pkgs = import nixpkgs { inherit system; } // self.packages.${system}; };
      })));

      templates = import ./templates { inherit (self) lib; };

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
            extraSpecialArgs = { inherit inputs; };
          };
        };
      };

      homeConfigurations =
        let
          username = "hugomoreau";
          system = "aarch64-darwin";
        in
        {
          "hugomoreau" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages."${system}";
            modules = [
              ./home
              {
                nixpkgs.overlays = custom_overlays system;
                home = {
                  inherit username;
                  homeDirectory = "/Users/${username}";
                };
                programs.home-manager.enable = true;
                my.home.devenv = {
                  enable = true;
                  type = "darwin";
                };
              }
            ];
            extraSpecialArgs = { inherit inputs; };
          };
        };

      nixosConfigurations =
        let
          system = "x86_64-linux";
          custom_modules = [
            { system.configurationRevision = self.rev or "dirty"; }
            home-manager.nixosModules.default
            { nixpkgs.overlays = custom_overlays system; }
          ] ++ (nixpkgs.lib.attrValues self.nixosModules);

          buildMachine = name: { system, hardwareModules }: nixpkgs.lib.nixosSystem {
            inherit system;
            modules = custom_modules ++ hardwareModules ++ [ (./. + "/machines/${name}") ];
            specialArgs = { inherit inputs; inherit (self) lib; };
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
