let
  keys = import ./keys.nix;

  all = with keys; [
    root.millenium
    agenix.millenium

    agenix.milano
  ];
in
{
  "users/root/hashed-password.age".publicKeys = all;
  "users/ryuki/hashed-password.age".publicKeys = all;

  "github/token.age".publicKeys = all;
}
