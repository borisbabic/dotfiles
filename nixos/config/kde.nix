{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; if config.services.xserver.enable then [
    kdeApplications.ark
    kdeApplications.dolphin-plugins
    kdeApplications.gwenview
    kdeApplications.kcachegrind
    kdeApplications.kdenetwork-filesharing
    kdeApplications.okular
    kdeApplications.spectacle
    yakuake
    kdeconnect
    kdeFrameworks.karchive
    kdeFrameworks.kcmutils
  ]  else [];
  services.xserver.desktopManager.plasma5.enable = config.services.xserver.enable;
}
