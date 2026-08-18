{ pkgs, lib, ryuki, git-hooks, system, ... }:

let
  pre-commit = git-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      clang-format = {
        enable = true;
        types_or = lib.mkForce [ "c" "c++" ];
        excludes = [
          "Core/.*"
          "Drivers/.*"
          "Middlewares/.*"
        ];
      };
      cmake-format.enable = true;
    };
  };
in
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

    ${pre-commit.shellHook}
  '';
}
