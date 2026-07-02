{ inputs, self, home-manager, ... }:

{
  nixos = import ./nixos;

  home = {
    home-manager = rec {
      useUserPackages = true;
      useGlobalPkgs = true;
      verbose = true;
      users = {
        ryuki = import ./home;
      };
      extraSpecialArgs = {
        inherit inputs useGlobalPkgs;
        lib = self.lib.extend (_: _: home-manager.lib);
        standaloneHome = false;
      };
    };
  };
}
