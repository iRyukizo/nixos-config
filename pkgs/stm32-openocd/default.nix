{ openocd
, autoreconfHook
, fetchFromGitHub
,
}:


openocd.overrideAttrs (
  finalAttrs: old: {
    pname = "stm32-openocd";
    version = "openocd-cubeide-r7";
    src = fetchFromGitHub {
      owner = "STMicroelectronics";
      repo = "openocd";
      tag = finalAttrs.version;
      hash = "sha256-1upCnj0QUTUc/t0tUt7sl+bjFq1ryLb455gr5Mls4UI=";
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
