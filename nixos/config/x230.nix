{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    acpi
    xorg.xf86inputsynaptics 
  ];
  #services.xserver.synaptics = {
    #accelFactor = "0.4";
    #enable = true;
    #horizEdgeScroll = true;
    #palmDetect = true;
    #tapButtons = true;
    #vertTwoFingerScroll = true;
    #vertEdgeScroll = true;
    #buttonsMap = [ 1 3 2 ];
    #fingersMap = [ 1 2 3 ];
  #};

  boot.loader.grub = pkgs.lib.mkForce {
	  enable = true;
	  device = "/dev/sda";
      useOSProber = true;
  };
  #services.tlp.enable = true;
  services.thermald.enable = true;
  #services.thinkfan.enable = true;
  hardware = {
    trackpoint.enable = true;
    pulseaudio = {
      /*configFile = pkgs.writeText "default.pa" ''*/
        /*load-module module-switch-on-connect*/
      /*'';*/
      package = pkgs.pulseaudioFull; #for bluetooth, i think
      enable = true;
      support32Bit = true; 
    };
    bluetooth.enable = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

  };
  nixpkgs.config.packageOverrides = pkgs: {
    bluez = pkgs.bluez5;
  };
  boot.kernelModules = [ "phc-intel" "acpi_call" "rtl88x2bu" ];
  boot.kernelParams = [
    "iwlwifi.11n_disable=1"
    "iwlwifi.11n_disable50=1"
    "iwlwifi.power_level=5"
    "iwlwifi.power_save=0"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call rtl88x2bu ];
  system.stateVersion = "22.11";

  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
  '';

  powerManagement = {
    enable = true;
  };
}
