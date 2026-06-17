let
  keys = import ./keys.nix;

  all = with keys; [
    root.dragon
    root.millenium

    agenix.dragon
    agenix.millenium
    agenix.milano
    agenix.NB23517B88
  ];
in
{
  "nixos/users/root/hashed-password.age".publicKeys = all;
  "nixos/users/ryuki/hashed-password.age".publicKeys = all;

  "home/github/token.age".publicKeys = all;
  "home/lichess/token.age".publicKeys = all;
  "home/nix/extra-config.age".publicKeys = all;
}
