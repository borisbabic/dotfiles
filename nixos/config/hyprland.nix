{ config, pkgs, ... }:
{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    #terminal
    kitty
    # notification center
    swaynotificationcenter
    # screensharing
    pipewire
    wireplumber
    # auth agent
    libsForQt5.polkit-kde-agent
    # qt
    qt5.qtwayland
    qt6.qtwayland
    # bar
    waybar
    # app launcher
    wofi
  ];
}
