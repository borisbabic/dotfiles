{ config, pkgs, ... }:
let enabled = config.services.xserver.enable;
{
  environment.systemPackages = with pkgs; if enabled then [
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
  services.xserver.desktopManager.gnome3.enable = enabled
  services.xserver.desktopManager.gnome3.enable = config.services.xserver.enable;
}

