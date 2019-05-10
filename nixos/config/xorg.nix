{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg_utils
    xorg.xev # 
    xorg.xkill
    #compton
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:escape";
    displayManager.sddm.enable = true;
    /*displayManager.slim.defaultUser = "boris";*/
    #displayManager.slim.enable = true;
    #displayManager.slim.defaultUser = "boris";
    #desktopManager.pantheon.enable = true;
    #desktopManager.xfce.enable = true;
    #desktopManager.mate.enable = true;
    windowManager.awesome = {
      enable = true;
      #package = pkgs.awesome-3-5;
      #package = pkgs.callPackage ./custom_packages/awesome3.5.nix {
        #cairo = pkgs.cairo.override { xcbSupport = true; };
      #};
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      /*package = pkgs.i3;*/
    };
  };
}

