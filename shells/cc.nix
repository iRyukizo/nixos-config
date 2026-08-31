{ pkgs, lib, ... }:

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

    gdb
  ] ++ lib.optionals (!stdenv.isDarwin) [
    valgrind
    strace
  ];
}
