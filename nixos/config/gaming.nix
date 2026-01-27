{ config, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    bottles
    lutris
  ];
  environment.sessionVariables = {
    # Force Steam to stop trying to be smart
    "STEAM_FORCE_DESKTOPUI_SCALING" = "1.0";
    # Tell XWayland apps (like Steam) not to scale themselves
    "GDK_SCALE" = "1";
  };
}
