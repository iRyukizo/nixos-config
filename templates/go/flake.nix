{
  description = "go-package";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    futils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "main";
    };
  };

  outputs =
    { self
    , futils
    , nixpkgs
    }@inputs:
    let
      inherit (futils.lib) eachDefaultSystem;

      version = builtins.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101");
    in
    eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    rec {
      packages = {
        go-package = pkgs.buildGoModule {
          pname = "go-package";
          inherit version;
          src = ./.;
          vendorHash = null;
        };
      };

      defaultPackage = packages.go-package;

      devShells.default = pkgs.mkShell {
        name = "go-package dev shell";
        nativeBuildInputs = with pkgs; [
          go
        ];
      };
    }
    );
}
