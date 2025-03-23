{ inputs, self, custom_overlays, ... }:

let
  inherit (inputs) home-manager nixpkgs;

  buildHomeConfiguration =
    username:
    { system, configModule, homePrefix ? "/home" }:
    home-manager.lib.homeManagerConfiguration {
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
nixpkgs.lib.mapAttrs buildHomeConfiguration {
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
