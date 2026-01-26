{ config, pkgs, ... }:

{
  networking.hostName ="nixos-legion5";
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.legion5.nix
    #./tmp.nix
    ./config/main.nix
    ];

# The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "25.11"; # change to the latest

}
