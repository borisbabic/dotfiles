
{ pkgs, lib, userHome, config, nix, ... }:
{
  boot.kernelModules = [
    # for undervolting
    "msr"
  ];
  boot.kernelParams = [
    # for undervolting
    "msr.allow_writes=on" 
  ];
  services.undervolt = {
    enable = true;
    coreOffset = -100;
  };

  specialisation.no-undervolt.configuration = {
    system.nixos.tags = ["no-undervolt"];
    services.undervolt = {
      enable = lib.mkForce false;
      coreOffset = lib.mkForce 0;
    };
  };
}
