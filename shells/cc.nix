{ pkgs ? import <nixpkgs> { }, system }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gcc

    gnumake
    cmake

    clang-tools
    ctags

    criterion
    gtest
  ] ++ (if (system != "aarch64-darwin") then
    with pkgs; [
      gdb
      strace
      valgrind
    ] else [
  ]);
}
