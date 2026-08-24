{ config, pkgs, ... }:
let
  hypr-prioritize-monitor = pkgs.writeShellApplication {
    name = "hypr-prioritize-monitor";

    # Include awk and coreutils explicitly in PATH for safety
    runtimeInputs = with pkgs; [
      gawk
      coreutils
    ];

    text = ''
      set -euo pipefail

      # 1. Ensure target monitor argument is provided
      if [ -z "''${1:-}" ]; then
          echo "Error: No target monitor specified." >&2
          echo "Usage: $0 <monitor_name>" >&2
          exit 1
      fi

      TARGET_MONITOR="$1"
      HYPRCTL="${pkgs.hyprland}/bin/hyprctl"

      # 2. Check if hyprctl binary exists at path
      if [ ! -x "$HYPRCTL" ]; then
          echo "Error: hyprctl binary not found at $HYPRCTL" >&2
          exit 1
      fi

      # Fetch current monitors output
      MONITORS_OUTPUT="$("$HYPRCTL" monitors 2>/dev/null)"

      # 3. Parse monitor names using AWK
      MAPFILE=()
      while IFS= read -r line; do
          MAPFILE+=("$line")
      done < <(echo "$MONITORS_OUTPUT" | awk '/^Monitor / {print $2}')

      # Check if target monitor exists in the list
      TARGET_INDEX=-1
      for i in "''${!MAPFILE[@]}"; do
          if [[ "''${MAPFILE[$i]}" == "$TARGET_MONITOR" ]]; then
              TARGET_INDEX=$i
              break
          fi
      done

      # 4. Exit if monitor is not found
      if [ "$TARGET_INDEX" -eq -1 ]; then
          echo "Error: Monitor '$TARGET_MONITOR' not found in hyprctl monitors." >&2
          exit 1
      fi

      # If target is the first monitor, no preceding monitors exist to process
      if [ "$TARGET_INDEX" -eq 0 ]; then
          echo "Target monitor '$TARGET_MONITOR' is the first monitor. No preceding monitors to cycle."
          exit 0
      fi

      # 5. Extract preceding monitors
      PRECEDING_MONITORS=("''${MAPFILE[@]:0:$TARGET_INDEX}")

      echo "Found target monitor '$TARGET_MONITOR'."
      echo "Preceding monitors to cycle: ''${PRECEDING_MONITORS[*]}"

      # 6. Disable preceding monitors using Hyprland Lua API
      for mon in "''${PRECEDING_MONITORS[@]}"; do
          echo "Disabling $mon..."
          "$HYPRCTL" eval "hl.monitor({ output = \"$mon\", disabled = true })" >/dev/null
      done

      # Pause to allow compositor to complete display topology updates
      sleep 0.5

      # 7. Re-enable preceding monitors
      for mon in "''${PRECEDING_MONITORS[@]}"; do
          echo "Re-enabling $mon..."
          "$HYPRCTL" eval "hl.monitor({ output = \"$mon\", disabled = false })" >/dev/null
      done

      echo "Done!"
    '';
  };
  in
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };
  programs.gamemode = {
    enable = true;
  };
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    #package = (pkgs.sunshine.override { cudaSupport = true;});
  };
  hardware.uinput.enable = true;
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];
  environment.systemPackages = with pkgs; [
    mangohud
    steam-tui
    steamcmd
    osu-lazer-bin
    heroic
    gamescope-wsi
    # bottles
    lutris
    # find a better home
    (pkgs.writeShellScriptBin "sunshine-prep" ''
        # Arguments: $1=Width, $2=Height, $3=FPS
        WIDTH=''${1:-2560}
        HEIGHT=''${2:-1600}
        FPS=''${3:-60}

        # Note: We use 'auto' for position and '1' for scale (tablet apps usually handle scaling)
        ${pkgs.hyprland}/bin/hyprctl keyword monitor SUNSHINE-1,''${WIDTH}x''${HEIGHT}@''${FPS},auto,1

        # 3. (Optional) Force focus or move a workspace there
        # ${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetooutput 10 SUNSHINE-1
      '')

      (pkgs.writeShellScriptBin "sunshine-undo" ''
        ${pkgs.hyprland}/bin/hyprctl keyword monitor SUNSHINE-1, disable
      '')

    hypr-prioritize-monitor
  ];
  environment.sessionVariables = {
    # Force Steam to stop trying to be smart
    "STEAM_FORCE_DESKTOPUI_SCALING" = "1.0";
    # Tell XWayland apps (like Steam) not to scale themselves
    "GDK_SCALE" = "1";
    "dfas" = "adsfa";
  };
  services.flatpak ={
    enable = true;
    remotes = [
      { name = "nvidia-gfn"; location = "https://international.download.nvidia.com/GFNLinux/flatpak/geforcenow.flatpakrepo"; }
      { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
    ];
    packages = [
      {appId = "com.nvidia.geforcenow"; origin = "nvidia-gfn"; }
      {appId = "com.google.AndroidStudio"; origin = "flathub"; }
    ];
    overrides = {
      "com.nvidia.geforcenow" = {
        Context.sockets = ["!wayland" ];
        SessionBus = {
          talk = ["org.freedesktop.portal.Desktop" "org.freedesktop.Flatpak" "org.freedesktop.portal.OpenURI"];
        };
      };
    };
  };
}
