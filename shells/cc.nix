{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gcc

    gnumake
    cmake

    clang-tools
    ctags
    gdb
    strace
    valgrind

    criterion
    gtest
  ];
}
