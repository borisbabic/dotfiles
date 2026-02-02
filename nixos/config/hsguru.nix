{ config, userHome, ... }:
{
  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = {};
  services.cloudflared = {
    enable = true;
    tunnels = {
      "02f819a3-62a1-4933-b488-a7dacddd558c" = {
        credentialsFile = "${config.sops.secrets.cloudflared-login.path}";
        ingress = {
          "localdev.hsguru.com" = {
            service = "http://localhost:8994";
          };
        };
        default = "http_status:404";
      };
    };
  };
  # services.openssh.enable = true;
  sops.defaultSopsFile = ../../secrets/keep_blank.yaml;
  sops.secrets.cloudflared-login = {
    owner = "cloudflared";
    group = "cloudflared";
    sopsFile = ../../secrets/cloudflared.yaml;
  };
  sops.age.keyFile = "${userHome}/.config/sops/age/keys.txt";
}
