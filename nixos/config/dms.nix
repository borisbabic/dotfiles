{ inputs, pkgs, ... }:
{
  imports = [inputs.dms-plugin-registry.modules.default ];
  programs.dsearch.enable = true;
  programs.dms-shell = {
    enable = true;
    plugins = {
      dankKDEConnect.enable = true;
      commandRunner.enable = true;
      emojiLauncher.enable = true;
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
