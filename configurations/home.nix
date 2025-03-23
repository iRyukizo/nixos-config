{ inputs, self, custom_overlays, ... }:

let
  inherit (inputs) home-manager nixpkgs;
  inherit (nixpkgs.lib) mapAttrs;
  inherit (home-manager.lib) homeManagerConfiguration;

  buildHomeConfiguration =
    username:
    { system, configModule, homePrefix ? "/home" }:
    homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."${system}";
      extraSpecialArgs = { inherit inputs; lib = self.lib.extend (_: _: home-manager.lib); };
      modules = [
        ./../modules/home
        {
          nixpkgs.overlays = custom_overlays system;
          programs.home-manager.enable = true;
          home = {
            inherit username;
            homeDirectory = "${homePrefix}/${username}";
            version.revision = self.rev or "dirty";
          };
        }
        configModule
      ];
    };
in
mapAttrs buildHomeConfiguration {
  "hugomoreau" = {
    system = "aarch64-darwin";
    homePrefix = "/Users";
    configModule = {
      my.home.devenv = {
        enable = true;
        type = "darwin";
      };
    };
  };
}
