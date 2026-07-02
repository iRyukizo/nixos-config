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
  ] ++ lib.optionals (!stdenv.isAarch64) [
    gdb
  ] ++ lib.optionals (!stdenv.isDarwin) [
    strace
    valgrind
  ];
}
