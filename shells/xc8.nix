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

    gdb
  ] ++ lib.optionals (!stdenv.isDarwin) [
    strace
    valgrind
  ] ++ lib.optionals (stdenv.isx86_64 && stdenv.isLinux) [
    ryuki.microchip-xc8
  ];
}
