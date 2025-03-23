{ inputs, self, home-manager, ... }:

{
  nixos = import ./nixos;

  home = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      verbose = true;
      users = {
        ryuki = import ./home;
      };
      extraSpecialArgs = { inherit inputs; lib = self.lib.extend (_: _: home-manager.lib); };
    };
  };
}
