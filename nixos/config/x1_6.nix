{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    powertop
    xorg.xf86inputsynaptics 
  ];
  services.xserver.dpi = 128;
  services.xserver.synaptics = {
    accelFactor = "6.9";
    enable = true;
    horizEdgeScroll = true;
    palmDetect = true;
    tapButtons = true;
    vertTwoFingerScroll = true;
    vertEdgeScroll = true;
    buttonsMap = [ 1 3 2 ];
    fingersMap = [ 1 2 3 ];
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=powersave
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
    '';

  };
  services.thermald.enable = true;
  /*services.thinkfan.enable = true;*/
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub = pkgs.lib.mkForce {
          enable = true;
          version = 2;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
  };


  hardware = {
    undervolt = {
      enable = true;
      core = -130;
      cache = -130;
      gpu = -30;
      uncore = 0; #todo make it optional
      analogio = 0; #todo make it optional
    };
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
    /*cpuFreqGovernor = "powersave"; #should be like ondemand*/

  };
  imports = 
    [
      ./custom_packages/undervolt.nix
    ];
}
