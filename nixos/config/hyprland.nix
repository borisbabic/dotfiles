{ inputs, pkgs, ... }:
{
  programs.regreet.enable = true;
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  programs.waybar = {
    enable = true;
  };
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  environment.systemPackages = with pkgs; [
    inputs.hyprsplit.packages.${stdenv.hostPlatform.system}.hyprsplit
    # clipboard manager
    clipse
    #lsp
    hyprls
    hyprlock
    hyprlauncher
    hyprsunset
    hyprpolkitagent
    hyprsysteminfo
    # hyprshutdown
    hyprland
    pipewire
    # terminal
    swaynotificationcenter
    # screensharing
    pipewire
    wireplumber
    # bar
    waybar
    qt5.qtwayland
    qt6.qtwayland
  ];
}
