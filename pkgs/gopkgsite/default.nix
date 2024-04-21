{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopkgsite";
  version = "unstable";

  # we must allow references to the original `go` package, as golint uses
  # compiler go/build package to load the packages it's linting.
  allowGoReference = true;

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "ddbbf7b6745ea937506c52fefb4d4688b5f0665e";
    sha256 = "sha256-DbOd4UB0QNwKjlhggV4aXaJeejYgkSMSqEWw77KK9dg=";
  };

  vendorHash = "sha256-WRqwp20l5EQg8OulH3Q7J8t2zNiZ0KOfWb3LMl0bSm4=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://pkg.go.dev";
    description = "A site for discovering Go packages";
    mainProgram = "pkgsite";
    license = licenses.bsd3;
  };
}
