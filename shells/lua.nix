{ pkgs, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    lua
    stylua
    lua-language-server
  ];
}
