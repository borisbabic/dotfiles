{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    powertop
    xorg.xf86inputsynaptics 
    iw
    wirelesstools
  ];
  services.xserver.dpi = 128;
  services.xserver.libinput.enable=true;
  services.xserver.synaptics = {
    accelFactor = "6.9";
    enable = false;
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
  #services.thermald.enable = true;
  /*services.thinkfan.enable = true;*/
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
  boot.initrd.kernelModules = ["acpi" "thinkpad-acpi" "acpi-call" "intel-rapl" ];
  boot.kernelParams = [
    "nopti" # disable meltdown fixes
    "acpi.ec_no_wakeup=1"
    #"iwlwifi.lar_disable=1" # remove selfmanaged regulatory domain | modinfo: disable LAR functionality (default: N) (bool)
    #"iwlwifi.power_level=5" # increase power level, I think | modinfo: default power save level (range from 1 - 5, default: 1) (int)
    #"iwlwifi.power_save=0" # turn off power saving, hopefully| modinfo: enable WiFi power management (default: disable) (bool)
    #"iwlmvm.power_scheme=1" # greater power for wifi |modinfo: power management scheme: 1-active, 2-balanced, 3-low power, default: 2 (int)
    #"cfg80211.ieee80211_regdom=US" # set US wifi regulatory domain, to allow 30 dbm, hopefully|enable WiFi power management (default: disable) (bool)
    "i915.enable_dc=1"
    "i915.enable_fbc=1"
    "i915.semaphores=1"
    "i915.enable_dp_mst=1"
    "i915.enable_guc=3"
    "intel_iommu=igfx_off"

  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub = pkgs.lib.mkForce {
          enable = true;
          version = 2;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
  };


   services.undervolt = { enable = true; coreOffset = "-100"; temp = "97"; };
  hardware = {
    trackpoint.enable = true;
    trackpoint.device="TPPS/2 Elan TrackPoint";
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
}
