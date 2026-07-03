{ inputs, self, ... }:

let
  inherit (inputs) agenix home-manager nixpkgs nixos-wsl;
  inherit (nixpkgs.lib) attrValues mapAttrs nixosSystem optional;

  system = "x86_64-linux";
  custom_modules = [
    { system.configurationRevision = self.rev or "dirty"; }
    home-manager.nixosModules.default
    { nixpkgs.overlays = (attrValues self.overlays) ++ [ agenix.overlays.default ]; }
  ] ++ (nixpkgs.lib.attrValues self.nixosModules);

  buildMachine = name: { system, hardwareModules, isWsl ? false }: nixosSystem {
    inherit system;
    modules = custom_modules ++
      hardwareModules ++
      (optional isWsl nixos-wsl.nixosModules.default) ++
      [ (./. + "/machines/${name}") ];
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
  NB23517B88-wsl = {
    inherit system;
    hardwareModules = [ ];
    isWsl = true;
  };
}
