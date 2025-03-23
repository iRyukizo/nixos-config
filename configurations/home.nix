{ inputs, self, ... }:

let
  inherit (inputs) home-manager nixpkgs;
  inherit (nixpkgs.lib) attrValues mapAttrs;
  inherit (home-manager.lib) homeManagerConfiguration;

  buildHomeConfiguration =
    username:
    { system, configModule, homePrefix ? "/home" }:
    homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."${system}";
      extraSpecialArgs = { inherit inputs; lib = self.lib.extend (_: _: home-manager.lib); };
      modules = [
        "${self}/modules/home"
        "${self}/modules/secrets"
        {
          nixpkgs.overlays = (attrValues self.overlays);
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
