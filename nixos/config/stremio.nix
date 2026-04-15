{pkgs,...}:
{
  systemd.user.services.stremio = {
    description = "Stremio Service Daemon";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.stremio-service}/bin/stremio-service";
      Restart = "always";
    };
    path = [pkgs.procps];
  };
  environment.systemPackages = with pkgs; [
    stremio-service
  ];
}
