{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; if config.services.xserver.enable then [
    plasma5Packages.ark
    plasma5Packages.dolphin-plugins
    plasma5Packages.gwenview
    plasma5Packages.kcachegrind
    plasma5Packages.kdenetwork-filesharing
    plasma5Packages.okular
    plasma5Packages.spectacle
    yakuake
    kdeconnect
    plasma5Packages.karchive
    plasma5Packages.kcmutils
  ]  else [];
  services.xserver.desktopManager.plasma5.enable = config.services.xserver.enable;
}
