
{ config, pkgs, ... }:

{
  boot.loader.grub = pkgs.lib.mkForce {
	  enable = true;
	  version = 2;
	  device = "/dev/sda";
  };
}
