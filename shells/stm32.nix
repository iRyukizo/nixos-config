{ pkgs, lib, ryuki, ... }:

pkgs.mkShell {
  name = "stm32-shell";

  nativeBuildInputs = with pkgs; [
    # Documentation
    doxygen
    graphviz

    gcc
    gcc-arm-embedded

    gnumake
    cmake
    ninja
    bear

    clang
    clang-tools
    ctags

    # Connection to ST devices
    stlink # ST Communication
    picocom # Shell
    ryuki.openocd-stm32 # Debugger Server

    gdb
    valgrind
  ] ++ lib.optionals (!stdenv.isDarwin) [
    strace
  ];

  shellHook = ''
    export CLANGD_FLAGS="--query-driver=${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-gcc"

    echo "Embedded CLANGD_FLAGS loaded"
  '';
}
