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
    valgrind
  ] ++ lib.optionals (!stdenv.isDarwin) [
    strace
  ];
}
