{ inputs, self, custom_overlays, ... }:

let
  inherit (inputs) home-manager nixpkgs;
  inherit (nixpkgs.lib) mapAttrs nixosSystem;

  system = "x86_64-linux";
  custom_modules = [
    { system.configurationRevision = self.rev or "dirty"; }
    home-manager.nixosModules.default
    { nixpkgs.overlays = custom_overlays system; }
  ] ++ (nixpkgs.lib.attrValues self.nixosModules);

  buildMachine = name: { system, hardwareModules }: nixosSystem {
    inherit system;
    modules = custom_modules ++ hardwareModules ++ [ (./. + "/machines/${name}") ];
    specialArgs = { inherit inputs; inherit (self) lib; };
  };
in
mapAttrs buildMachine {
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
}
