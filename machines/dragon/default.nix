{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  home-manager.users.ryuki = {
    my.home = {
      devenv.enable = true;
    };
  };

  my.packages = {
    core.enable = true;
  };

  my.system = {
    enableBasic = true;
    networking = {
      hostname = "dragon";
      interfaces = [ "eno1" "wlp3s0" "enp60s0u1u3c2" ];
    };
    ssh.usersAndKeys = [
      {
        user = "ryuki";
        keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0E4FpIk18/lPJ7cSik729BJLJfQHiNyQh8XcQM/rzFkAzWJ61BRQiw0oQaq58rOGBpkocIVjgpEh9jX1x8+qzmBEo4UoSky2qUokO/DPv0uH+LrQofUV2Ix5EUNalYZGLI1G6NpuRBe5Ha3jYsREZz2A0YDO3/S7f7gJFl8Zj6/JIjsbuURBNNXKU3/9j+vDZrNtZXXu5aPhpahNqmXmD0YlfjB5dEjGdryqe0EbTKsMIA++qt8XMzabicVdzRBM/zON2w2wUnw7IFS0/VRVBA2l08bM0oW7saaXtKHvl6759rWnxsgsvww/NCC6u3aO/pcU4mBMafNcumDAi5k4FGGhgjEZxwAZCnnI8J7sKuqcJurZwI7xCrPb3KbKL4snH6CJ0YY8cVALrSN0m3ocikZtUflwkSxlC6XRCrVh4oP3b/+7FqXIldFLKVJ0FBljoZoEfQdkA6UQfJxjQOTx8/wYz92egxT7eRKoXMfIOg4AryRZTP695nX7MXdylGAU= ryuki@discovery" ];
      }
    ];
  };

  system.stateVersion = "23.05";
}
