{ openocd
, autoreconfHook
, fetchFromGitHub
, fetchurl
,
}:


openocd.overrideAttrs (
  finalAttrs: old: {
    pname = "openocd-stm32";
    version = "openocd-cubeide-r7";
    src = fetchFromGitHub {
      owner = "STMicroelectronics";
      repo = "openocd";
      tag = finalAttrs.version;
      hash = "sha256-HjyxTGg/4ALevoWbQ7tLc3KWHg2dIP1NSgv5QT0Z/qw=";
      fetchSubmodules = false;
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [
      autoreconfHook
    ];

    patches = [
      ./001-stm32c5-add-xldr.patch
    ];

    postInstall = old.postInstall + ''
      mkdir -p $out/share/openocd/scripts/flash
      cp ${fetchurl {
        url = "https://raw.githubusercontent.com/STMicroelectronics/stm32c5xx-dfp/main/Flash/STM32C5%5B56%5Dx.xldr";
        hash = "sha256-ExeEwuTrRYkgC2FOVrg6vSGjSQbB/Uhco9gGN40ocy0=";
      }} "$out/share/openocd/scripts/flash/STM32C5[56]x.xldr"
      substituteInPlace $out/share/openocd/scripts/target/stm32c5x.cfg \
        --replace-fail 'flash/STM32C5\[56\]x.xldr' $out'/share/openocd/scripts/flash/STM32C5\[56\]x.xldr'
    '';


    meta = openocd.meta // {
      description = "STMicroelectronics fork of OpenOCD";
      homepage = "https://github.com/STMicroelectronics/openocd";
    };
  }
)
