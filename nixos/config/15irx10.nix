# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, userHome, config, nix, ... }:

# to disable battery charge limit do the following:
# sudo legion_cli --donotexpecthwmon batteryconservation-disable

{
  # for cachyos kernels
  nix.settings.substituters = [ "https://cache.garnix.io" "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  # Use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelPackages = pkgs.linuxKernel.packagesFor pkgs.cachyosKernels.linux-cachyos-latest-lto-x86_64-v4;
  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
  services.thermald.enable = lib.mkDefault true;
  # DO NOT ENABLE
  # MESSES WITH DONGLES
  # BOTH FOR HEADSET MX3
  # powerManagement.powertop.enable = true;
  users.users.boris.extraGroups = ["video"];
  services.hyprdynamicmonitors.configFile = "${userHome}/.config/hypr/hyprdynamicmonitors/15irx10/config.toml";

  services.logind.settings.Login = {
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitch = "suspend";
  };
  environment.systemPackages = with pkgs; [
    brightnessctl
    lenovo-legion
  ];
  hardware.bluetooth.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages =  with pkgs; [
      intel-media-driver
      nvidia-vaapi-driver
    ];
  };
  environment.variables = {
    # gemini says can cause issues
    # NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "nvidia";
  };
  services.xserver.videoDrivers = [ "nvidia"];
  nix.settings = {
    max-jobs = 4;
    cores = 3;
  };
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
    powerManagement.finegrained = false;
  };

  boot.kernelParams = [
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
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
  # services.undervolt = {
  #   enable = true;
  #   coreOffset = -50;
  # };

  # specialisation.no-undervolt.configuration = {
  #   system.nixos.tags = ["no-undervolt"];
  #   services.undervolt = {
  #     enable = lib.mkForce false;
  #     coreOffset = lib.mkForce 0;
  #   };
  # };

  specialisation.on-the-go.configuration = {
    system.nixos.tags = ["on-the-go"];
    hardware.nvidia.prime = {
      offload = {
        enable = lib.mkForce true;
        enableOffloadCmd = lib.mkForce true;
      };
      sync.enable = lib.mkForce false;
    };
    hardware.nvidia.powerManagement.finegrained = lib.mkForce true;
  };
  # try to fix wifi issue. Suggested by gemini
  hardware.enableRedistributableFirmware = true;

  boot.kernel.sysfs = {
    module.zswap.parameters = {
      enabled = true;
      zpool = "zsmalloc";
      compressor = "zstd";
    };
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
