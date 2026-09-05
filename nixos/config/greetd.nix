{
  pkgs,
  ...
}: let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  usbId = "046d:082d";
  usbSerial = "BAE99B5F";
  # from gemini
  sessionDirs = "/run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions";
  hyprland-session = "${pkgs.hyprland}/share/wayland-sessions/";
  tuigreet_command="${tuigreet} --time --remember --remember-session --sessions ${sessionDirs}";
  command = ''
    if ${pkgs.usbutils}/bin/lsusb -d ${usbId} | grep -i iserial | grep "${usbSerial}"; then 
      exec uwsm start hyprland-uwsm.desktop
    else
      exec ${tuigreet_command}
    fi
  '';
in {
  environment.systemPackages = [ pkgs.usbutils ];
  services.greetd = {
    enable = true;
    settings = {
        # initial_session = {
        # command = command;
        # user = "greeter";
      # };
      default_session = {
        command = tuigreet_command;
        user = "greeter";
      };
    };
  };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
