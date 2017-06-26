{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdeApplications.ark
    kdeApplications.dolphin-plugins
    kdeApplications.gwenview
    kdeApplications.kate
    kdeApplications.kcachegrind
    kdeApplications.kdenetwork-filesharing
    kdeApplications.okular
    kdeApplications.spectacle
    kdeconnect
    kdeFrameworks.karchive
    kdeFrameworks.kcmutils
  ];
  services.xserver = {
    desktopManager.plasma5.enable = true;
  };
}
