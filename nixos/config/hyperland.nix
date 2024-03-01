
{ config, pkgs, ... }:
{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    #terminal
    kitty
    # notification center
    swaync
    # screensharing
    pipewire
    wireplumber
    # auth agent
    polkilt-kde-agent
    # qt
    qt5-wayland
    qt6-wayland
    # bar
    waybar
    # app launcher
    wofi
  ];
}
