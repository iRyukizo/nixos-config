{ bubblewrap
, buildFHSEnv
, fakeroot
, fetchurl
, glibc
, lib
, rsync
, stdenvNoCC
}:

let
  fhsEnv = buildFHSEnv {
    name = "mplab-x-build-fhs-env";
    targetPkgs = pkgs: with pkgs; [
      fakeroot
      glibc
      zlib
      expat
      libxcrypt-legacy
    ];
  };

in
stdenvNoCC.mkDerivation rec {
  pname = "microchip-xc8";
  version = "3.10";
  src = fetchurl {
    url =
      "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/xc8-v${version}-full-install-linux-x64-installer.run";
    hash = "sha256-YogDuW9GilmB1rwdCl5sf6gJ5Nh+PMqWGAXiqFf1hG4=";
  };

  nativeBuildInputs = [ bubblewrap rsync ];

  unpackPhase = ''
    runHook preUnpack

    install $src installer.run

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    rsync -a ${fhsEnv.fhsenv}/ chroot/
    find chroot -type d -exec chmod 755 {} \;
    echo "root:x:0:0:root:/root:/bin/bash" > chroot/etc/passwd
    echo "root:x:0:root" > chroot/etc/group
    mkdir -p chroot/tmp/home

    echo "$out" >outdir.txt

    bwrap \
      --bind chroot / \
      --dev /dev \
      --proc /proc \
      --tmpfs /tmp \
      --bind /nix /nix \
      --ro-bind installer.run /installer \
      --setenv HOME /tmp/home \
      -- /bin/fakeroot /installer \
      --LicenseType FreeMode \
      --mode unattended \
      --netservername localhost \
      --prefix "$out"

    runHook postInstall
  '';
  dontFixup = true;

  meta = with lib; {
    homepage =
      "https://www.microchip.com/en-us/tools-resources/develop/mplab-xc-compilers/xc8";
    description =
      "Microchip's MPLAB XC8 C compiler toolchain 8-bit PIC and AVR microcontrollers (MCUs)";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
