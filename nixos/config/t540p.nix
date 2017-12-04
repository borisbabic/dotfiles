{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    acpi
    xorg.xf86inputsynaptics 
  ];
  services.xserver.synaptics = {
    accelFactor = "0.4";
    enable = true;
    horizEdgeScroll = true;
    palmDetect = true;
    tapButtons = true;
    vertTwoFingerScroll = true;
    vertEdgeScroll = true;
    buttonsMap = [ 1 3 2 ];
    fingersMap = [ 1 2 3 ];
  };

  services.tlp.enable = true;
  /*services.thermald.enable = true;*/
  /*services.thinkfan.enable = true;*/
  hardware = {
    trackpoint.enable = true;
    pulseaudio = {
      package = pkgs.pulseaudioFull; #for bluetooth, i think
      enable = true;
      support32Bit = true;
    };
    bluetooth.enable = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

  };
  nixpkgs.config.packageOverrides = pkgs: {
    bluez = pkgs.bluez5;
  };


  powerManagement = {
    enable = true;
  };
}
