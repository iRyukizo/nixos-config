let
  keys = import ./keys.nix;

  all = with keys; [
    ryuki.milano
    ryuki.millenium
    root.millenium
  ];
in
{
  "users/root/hashed-password.age".publicKeys = all;
  "users/ryuki/hashed-password.age".publicKeys = all;
}
