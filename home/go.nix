{ config, ... }:

{
  programs.go = {
    enable = true;
    goPath = "go";
    goBin = "go/bin";
  };

  home.sessionPath = [
    # Some packages are not packaged in go, so old `go install pkgs@version` makes it
    "$HOME/go/bin"
  ];
}
