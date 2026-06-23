local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
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
                package = i(3, "nix-prefetch-git"),
            }
        )
    ),
}
