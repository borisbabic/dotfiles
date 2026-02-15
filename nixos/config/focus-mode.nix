{pkgs, ...}:
{
  networking.stevenblack = {
    enable = false;
    block = [ "social" "fakenews" ]; # Blocks common social media sites
  };
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "stevenblack.service" &&
          subject.isInGroup("stevenblack")) {
        return polkit.Result.YES;
      }
    });
  '';

  environment.systemPackages =
  [
    (pkgs.writeShellScriptBin "focus-start" ''
        systemctl start stevenblack.service
    '')
    (pkgs.writeShellScriptBin "focus-stop" ''
        systemctl start stevenblack.service
    '')
  ];
  users.groups.stevenblack = {
    members = ["boris"];
  };
}
