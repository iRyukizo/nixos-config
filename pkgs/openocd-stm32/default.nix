{ openocd
, autoreconfHook
, fetchFromGitHub
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

    meta = openocd.meta // {
      description = "STMicroelectronics fork of OpenOCD";
      homepage = "https://github.com/STMicroelectronics/openocd";
    };
  }
)
