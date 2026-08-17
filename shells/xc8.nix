{ pkgs, lib, ryuki, ... }:

pkgs.mkShell {
  name = "xc8-shell";

  nativeBuildInputs = with pkgs; [
    doxygen
    graphviz

    gnumake
    cmake
    bear

    clang
    clang-tools
    ctags

    ryuki.microchip-xc8

    gdb
    valgrind
  ] ++ lib.optionals (!stdenv.isDarwin) [
    strace
  ];
}
