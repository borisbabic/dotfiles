{pkgs,...}:
{
  systemd.user.services.stremio = {
    description = "Stremio Service Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.stremio-service}/bin/stremio-service";
      Restart = "always";
    };
  };
  environment.systemPackages = with pkgs; [
    stremio-service
  ];
}
