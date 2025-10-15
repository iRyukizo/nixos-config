{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "noto-fonts-cjk-sans-tc";
  version = "20251015";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "noto-cjk";
    tag = "Sans2.004";
    sha256 = "sha256-iBZqEtE67Z/OKcGsLATAAFWYLTmGqWCky+pTb/+WE1M=";
    sparseCheckout = [
      "Sans/SubsetOTF/TC"
      "Sans/OTF/TraditionalChinese"
    ];
  };

  installPhase =
    ''
      install -m444 -Dt $out/share/fonts/opentype/noto-sans-cjk Sans/OTF/TraditionalChinese/*.otf
      install -m444 -Dt $out/share/fonts/opentype/noto-sans Sans/SubsetOTF/TC/*.otf
    '';

  meta = with lib; {
    description = "Noto fonts for Traditional Chinese CJK languages";
    homepage = "https://www.google.com/get/noto/help/cjk/";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
