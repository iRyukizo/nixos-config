{ pkgs, ... }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nil
    nixpkgs-fmt
  ];
}
