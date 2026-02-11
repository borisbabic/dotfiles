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
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    mangohud
    steam-tui
    steamcmd
    gamescope-wsi
    bottles
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
