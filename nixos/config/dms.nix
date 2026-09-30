{ inputs, pkgs, lib, ... }:
# let
  # patched = pkgs.dms-shell.overrideAttrs (oldAttrs: {
  #   src = pkgs.fetchFromGitHub {
  #     owner = "borisbabic";
  #     repo = "DankMaterialShell";
  #     rev = "master";
  #     hash = "sha256-wy0zsZBV1pOkpLIVl5cDGmQYPz+53mDZ8kS/zHVZgB4=";
  #   };
  # }); in
{
  imports = [
    inputs.dms-plugin-registry.nixosModules.default
    inputs.dank-calendar.nixosModules.default
    # inputs.dms.nixosModules.dank-material-shell
  ];
  programs.dank-calendar.enable = true;
  programs.dsearch.enable = true;
  programs.dms-shell = {
    enable = true;
    plugins = {
      dankKDEConnect.enable = true;
      commandRunner.enable = true;
      emojiLauncher.enable = true;
      powerUsagePlugin.enable = true;
    };
    systemd = {
      enable = false;             # Systemd service for auto-start
      # target = "graphical-session.target";
      restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
    };
    #enableVPN = true;                  # VPN management widget
    #enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    #enableAudioWavelength = true;      # Audio visualizer (cava)
    # enableCalendarEvents = true;       # Calendar integration (khal)
  };
  services.displayManager.dms-greeter = {
    enable = false;
    configHome = "/home/boris";
    configFiles = [
      "/home/boris/.config/DankMaterialShell/settings.json"
    ];
    compositor = {
      name = "hyprland";
    };
  };
}
