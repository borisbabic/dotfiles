# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };

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
  };
  # try to fix wifi issue. Suggested by gemini
  hardware.enableRedistributableFirmware = true;

  ###### <fix hibernate, suggested by gemini>
  hardware.nvidia.powerManagement.enable = true;
  # This option can sometimes help with "black screen" resume issues
  # by preserving video memory in /tmp
  hardware.nvidia.powerManagement.finegrained = false;
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  ###### </fix hibernate, suggested by gemini>

}
