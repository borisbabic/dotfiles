{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg_utils
    xorg.xbacklight
    xorg.xev # 
    xorg.xkill
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:escape";
    displayManager.slim.enable = true;
    displayManager.slim.defaultUser = "boris";
    windowManager.awesome = {
      enable = true;
      package = pkgs.awesome-3-5;
    };
    windowManager.xmonad = {
      enableContribAndExtras = true;
      enable = true;
    };
  };
}

