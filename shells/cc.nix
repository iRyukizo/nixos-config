{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gcc

    gnumake
    cmake
    bear

    clang
    clang-tools
    ctags

    criterion
    gtest
  ] ++ lib.optional (!stdenv.isAarch64) [
    gdb
  ] ++ lib.optional (!stdenv.isDarwin) [
    strace
    valgrind
  ];
}
