{ openocd
, autoreconfHook
, fetchFromGitHub
, fetchurl
,
}:


openocd.overrideAttrs (
  finalAttrs: old: {
    pname = "openocd-stm32";
    version = "v2.2.0";
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
      ${
        let files = [
          {
            name = "STM32C5%5B34%5Dx.xldr";
            unespacedName = "STM32C5[34]x.xldr";
            hash = "sha256-RkVXTydPUnTehp29Kms1/XnRNPfsByJMPxftLUDHuLY=";
          }
          {
            name = "STM32C5%5B56%5Dx.xldr";
            unespacedName = "STM32C5[56]x.xldr";
            hash = "sha256-ExeEwuTrRYkgC2FOVrg6vSGjSQbB/Uhco9gGN40ocy0=";
          }
          {
            name = "STM32C5%5B9A%5Dx.xldr";
            unespacedName = "STM32C5[9A]x.xldr";
            hash = "sha256-uarOyDdhPyc7DYj7PKQcXFJxJ1L9JicZWd0DpB2rjlM=";
          }
        ];
        in
        builtins.concatStringsSep "\n" (
          map (file: ''
            cp ${fetchurl {
              url = "https://github.com/STMicroelectronics/stm32c5xx-dfp/raw/refs/tags/2.1.0/Flash/${file.name}";
              hash = file.hash;
            }} "$out/share/openocd/scripts/flash/${file.unespacedName}"
          ''
          ) files 
        )
      }
      substituteInPlace $out/share/openocd/scripts/target/stm32c5x.cfg \
        --replace-fail 'flash/' $out'/share/openocd/scripts/flash/'
    '';


    meta = openocd.meta // {
      description = "STMicroelectronics fork of OpenOCD";
      homepage = "https://github.com/STMicroelectronics/openocd";
    };
  }
)
