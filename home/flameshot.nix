{ config, ... }:

{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath = "/home/ryuki/Pictures/screenshots";
      };
    };
  };
}
