{ config, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.gamemode = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    mangohud
    steam-tui
    steamcmd
    gamescope-wsi
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
