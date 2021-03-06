{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    powertop
    xorg.xf86inputsynaptics 
    iw
    wirelesstools
    brightnessctl
    acpilight #brightness
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
    # enable = true; TEMP
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=powersave
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
    '';

  };
  services.throttled.enable = true; # testing out, taken from the nixos-hardware repo
  services.thermald.enable = true;
  #services.thinkfan.enable = true;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_4_14;
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  boot.initrd.kernelModules = ["acpi" "thinkpad-acpi" "acpi-call" ];
  boot.kernelParams = [
    # "nopti" # disable meltdown fixes
    "mitigations=off" # disable fixes for meltdown, spectre and co
    "acpi.ec_no_wakeup=1"
    #"iwlwifi.lar_disable=1" # remove selfmanaged regulatory domain | modinfo: disable LAR functionality (default: N) (bool)
    #"iwlwifi.power_level=5" # increase power level, I think | modinfo: default power save level (range from 1 - 5, default: 1) (int)
    #"iwlwifi.power_save=0" # turn off power saving, hopefully| modinfo: enable WiFi power management (default: disable) (bool)
    #"iwlmvm.power_scheme=1" # greater power for wifi |modinfo: power management scheme: 1-active, 2-balanced, 3-low power, default: 2 (int)
    #"cfg80211.ieee80211_regdom=US" # set US wifi regulatory domain, to allow 30 dbm, hopefully|enable WiFi power management (default: disable) (bool)
    # "i915.enable_dc=1" # on for power saving
    # "i915.enable_fbc=1" # on for power saving
    # "i915.semaphores=1" # not avialbe?
    "i915.enable_dp_mst=0" # disable daisy chain, had issues at work
    # "i915.enable_guc=2" # see https://wiki.archlinux.org/index.php/Intel_graphics#Enable_GuC_/_HuC_firmware_loading # experienced some freezing so removed
    "intel_iommu=igfx_off" # disable passthrough for VMs or something like that

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
      #extraConfig = ''
      #[Profile output:a2dp_sink+input:headset_head_unit]
      #description = A2dp output and headset input
      #output-mappings = a2dp_sink
      #input-mappings = headset_head_unit
      #'';
    };
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  nixpkgs.config.packageOverrides = pkgs: {
    bluez = pkgs.bluez5;
  };

  swapDevices = [{
    device = "/var/swapfile";
    size = 16384;
  }];
  powerManagement = {
    enable = true;
    /*cpuFreqGovernor = "powersave"; #should be like ondemand*/

  };

  systemd.services.cpu-throttling = {
    enable = true;
    description = "CPU Throttling Fix";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    path = [ pkgs.msr-tools ];
    script = "wrmsr -a 0x1a2 0x3000000";
    serviceConfig = {
      Type = "oneshot";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  systemd.timers.cpu-throttling = {
    enable = true;
    description = "CPU Throttling Fix";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    timerConfig = {
      OnActiveSec = 60;
      OnUnitActiveSec = 60;
      Unit = "cpu-throttling.service";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  ## use iris https://nixos.wiki/wiki/Intel_Graphics 
  environment.variables = {
    MESA_LOADER_DRIVER_OVERLOAD = "iris";
  };
  hardware.opengl = {
    package = (pkgs.mesa.override {
      galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
    }).drivers;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

}
