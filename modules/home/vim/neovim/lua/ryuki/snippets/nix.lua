local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "shell",
        fmt(
            [[
                {{ pkgs ? import <{source}> {{ }} }}:

                pkgs.mkShell {{
                  name = "{name}-env";
                  nativeBuildInputs = with pkgs; [
                    {package}
                  ];
                }}
            ]],
            {
                source = i(1, "nixpkgs"),
                name = i(2, "nix"),
                package = i(0, "nix-prefetch-git"),
            }
        )
    ),
    s(
        "devshell",
        fmt(
            [[
                devShells.{name} = pkgs.mkShell {{
                  name = "{name_rep} dev shell";
                  nativeBuildInputs = with pkgs; [
                    {pkg}
                  ];
                }};
            ]],
            {
                name = i(1, "default"),
                name_rep = rep(1),
                pkg = i(0, "# Add packages"),
            }
        )
    ),
    s(
        "version",
        fmt([[version = {version};]], {
            version = i(1, os.date("%Y-%m-%d")),
        })
    ),
    s(
        "mkder",
        fmt(
            [[
                {source}.mkDerivation {{
                  pname = "{pname}";
                  version = "{version}";

                  {data}

                  meta = with lib; {{
                    description = "{description}";
                  }};
                }}
            ]],
            {
                source = i(1, "pkgs.stdenv"),
                pname = i(2, "my-package"),
                version = i(3, os.date("%Y-%m-%d")),
                description = i(4, "My Description"),
                data = i(0, "# Add sources and installation process"),
            }
        )
    ),
    s(
        "pkgs",
        fmt(
            [[
                {packages} = {pkgs}[
                  {pkg}
                ];
            ]],
            {
                packages = i(1, "packages"),
                pkgs = i(2, "with pkgs; "),
                pkg = i(0, "# Add packages"),
            }
        )
    ),
    s(
        "pythonpkg",
        fmt(
            [[
                (python{ver}.withPackages (pythonPackages: with pythonPackages; [
                  {pkg}
                ]))
            ]],
            {
                ver = i(1, "312"),
                pkg = i(0, "# Add packages"),
            }
        )
    ),
    s(
        "flake",
        fmt(
            [[
                {{
                  description = "{name} flake";

                  inputs = {{
                    nixpkgs = {{
                      type = "github";
                      owner = "NixOS";
                      repo = "nixpkgs";
                      ref = "nixos-unstable";
                    }};

                    futils = {{
                      type = "github";
                      owner = "numtide";
                      repo = "flake-utils";
                      ref = "main";
                    }};
                  }};

                  outputs =
                    {{
                      self,
                      futils,
                      nixpkgs,
                    }}@inputs:
                    let
                      inherit (futils.lib) eachDefaultSystem;

                      version = builtins.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101");
                    in
                    eachDefaultSystem (
                      system:
                      let
                        pkgs = import nixpkgs {{ inherit system; }};
                      in
                      {{
                        devShells.default = pkgs.mkShell {{
                          name = "{rep_name} dev shell";
                          nativeBuildInputs = with pkgs; [
                            {pkg}
                          ];
                        }};
                      }}
                    );
                }}
            ]],
            {
                name = i(1, "Name"),
                pkg = i(0, "# Add packages"),
                rep_name = rep(1),
            }
        )
    ),
}
