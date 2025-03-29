{ inputs, self, ... }:

let
  inherit (inputs) agenix home-manager mac-app-util nixpkgs;
  inherit (nixpkgs.lib) attrValues mapAttrs;
  inherit (home-manager.lib) homeManagerConfiguration;

  buildHomeConfiguration =
    username:
    { system, configModule, homePrefix ? "/home" }:
    homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."${system}";
      extraSpecialArgs = { inherit inputs; lib = self.lib.extend (_: _: home-manager.lib); };
      modules = [
        # Mac App util on darwin will automatically creates trampoline apps,
        # but be careful as updating apps will create doubles. Then when
        # updating, try to sync apps accordingly.
        mac-app-util.homeManagerModules.default
        "${self}/modules/home"
        {
          nixpkgs.overlays = (attrValues self.overlays) ++ [ agenix.overlays.default ];
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
      my.home = {
        aerospace.enable = true;
        terminal.alacritty.enable = true;
        devenv = {
          enable = true;
          type = "darwin";
        };
      };
    };
  };
}
