# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, userHome, config, nix, ... }:

# to disable battery charge limit do the following:
# sudo legion_cli --donotexpecthwmon batteryconservation-disable

{
  imports = [
    # ./undervolt.nix
  ];
  # Use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #
  # programs.coolercontrol.enable = true;
  # boot.kernelPackages = pkgs.linuxKernel.packagesFor pkgs.cachyosKernels.linux-cachyos-latest-lto-x86_64-v4;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
  services.thermald.enable = lib.mkDefault true;
  # DO NOT ENABLE
  # MESSES WITH DONGLES
  # BOTH FOR HEADSET MX3
  # powerManagement.powertop.enable = true;
  users.users.boris.extraGroups = ["video"];
  services.logind.settings.Login = {
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitch = "suspend";
  };
  services.scx = {
    enable = false;
  };
  services.scx-loader = {
    enable = true;
    # Pulls the default TOML policies for gaming, power saving, etc.
    config = {
      default_sched = "scx_bpfland";
    };
  };
  environment.systemPackages = with pkgs; [
    scx.full
    scx-loader
    powertop
    brightnessctl
    lenovo-legion
    config.boot.kernelPackages.turbostat
  ];
  hardware.bluetooth.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages =  with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };
  services.xserver.videoDrivers = [ "nvidia"];
  nix.settings = {
    max-jobs = 4;
    cores = 3;
  };
  # hardware.nvidia = {
  #   open = true;
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   prime = {
  #     sync.enable = true;
  #     intelBusId = "PCI:0@0:2:0";
  #     nvidiaBusId = "PCI:1@0:0:0";
  #   };
  #   powerManagement.finegrained = false;
  # };

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      # sync supposedly doesn't work with wayland? Huh? :shrug:
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
  boot.initrd.kernelModules = [ "xe" ];
  boot.kernelParams = [
    "i915.enable_guc=3"
    "i915.enable_sagv=0"
    "i915.enable_fbc=0"
    "i915.enable_psr=0"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    # modern software sleep, faster, can be more battery wasting 
    "mem_sleep_default=s2idle"
    # "i915.force_probe=!a788"
    # "xe.force_probe=a788"
  ];

  # fileSystems."/boot/windows" = {
  #   device = "/dev/disk/by-uuid/32E6-6700";
  #   fsType = "vfat";
  # };
  # boot.loader.systemd-boot.extraEntries = {
  #   "windows.conf" = ''
  #     title Windows
  #     sort-key 0
  #     efi /windows/EFI/Microsoft/Boot/bootmgfw.efi
  #   '';
  # };
  # boot.loader.systemd-boot.configurationLimit = 20;
  # specialisation.i915.configuration = {
  #   system.nixos.tags = [ "i915" ];
  #   boot.initrd.kernelModules = lib.mkForce [ "i915" ];
  #   boot.kernelParams = lib.mkForce [
  #     "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  #     # Disables PSR and FBC to prevent the Firefox hang under i915
  #     "i915.enable_psr=0"
  #     "i915.enable_fbc=0"
  #   ];
  # };
  # specialisation.on-the-go.configuration = {
  #   system.nixos.tags = ["on-the-go"];
  #   hardware.nvidia.prime = {
  #     offload = {
  #       enable = lib.mkForce true;
  #       enableOffloadCmd = lib.mkForce true;
  #     };
  #     sync.enable = lib.mkForce false;
  #   };
  #   hardware.nvidia.powerManagement.finegrained = lib.mkForce true;
  # };

  services.power-profiles-daemon.enable = false;
  services.tuned = {
    enable = true;
  };

  # --- Battery Specialisation ---
  # specialisation."on-battery".configuration = {
  #   system.nixos.tags = [ "on-battery" ];
  #
  #   # 1. Force PCIe ASPM and NVMe Latency Management
  #   boot.kernelParams = [
  #     "pcie_aspm=force"                           # Force ASPM on ports marked "Disabled"
  #     "pcie_aspm.policy=powersave"
  #     "nvme_core.default_ps_max_latency_us=5500" # Force NVMe into deep sleep states
  #   ];
  #
  #   # 2. Strict Power Limits & Disabling CPU Turbo
  #   services.power-profiles-daemon.enable = false;
  #   services.tlp = {
  #     enable = true;
  #     settings = {
  #       CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #       CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #       CPU_BOOST_ON_BAT = 0;
  #       CPU_HWP_DYN_BOOST_ON_BAT = 0;
  #       PLATFORM_PROFILE_ON_BAT = "low-power";
  #     };
  #   };
  #
  #   # 4. Force Nvidia dGPU into Runtime D3 (D3cold Power Off)
  #   hardware.nvidia = {
  #     powerManagement.enable = lib.mkForce true;
  #     powerManagement.finegrained = lib.mkForce true; # Allows complete dGPU power-off (D3cold)
  #     dynamicBoost.enable = false;
  #     prime = {
  #       sync.enable = lib.mkForce false;
  #       offload.enable = lib.mkForce true;
  #       offload.enableOffloadCmd = lib.mkForce true;
  #     };
  #   };
  # };
  # try to fix wifi issue. Suggested by gemini
  hardware.enableRedistributableFirmware = true;

  # services.lact = {
  #   enable = true;
  # };

  boot.zswap = {
    enable = true;
    zpool = "zsmalloc";
    compressor = "zstd";
  };
  # Disable integrated camera
  services.udev.extraRules = ''
    # Disable specific USB device
    SUBSYSTEM=="usb", ATTR{idVendor}=="04f2", ATTR{idProduct}=="b83e", ATTR{authorized}="0"
  '';
  # boot.blacklistedKernelModules = [
  # # ram temp sensor that messes up hibernate
  # "spd5118"
  # ];
  ###### </fix hibernate, suggested by gemini>


}
