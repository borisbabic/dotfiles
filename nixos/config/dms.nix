{ inputs, pkgs, ... }:
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
    inputs.dms-plugin-registry.modules.default
    inputs.dms.nixosModules.dank-material-shell
  ];
  programs.dsearch.enable = true;
  programs.dank-material-shell = {
    enable = true;
    plugins = {
      dankKDEConnect.enable = true;
      commandRunner.enable = true;
      emojiLauncher.enable = true;
      powerUsagePlugin.enable = true;
    };
    systemd = {
      enable = true;             # Systemd service for auto-start
      target = "graphical.target";
      restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
    };
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    # enableClipboard = true;            # Clipboard history manager
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
  };
  services.displayManager.dms-greeter = {
    enable = true;
    configHome = "/home/boris";
    configFiles = [
      "/home/boris/.config/DankMaterialShell/settings.json"
    ];
    compositor = {
      name = "hyprland";
    };
  };
}
