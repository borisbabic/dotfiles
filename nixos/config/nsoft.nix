{ config, pkgs, ... }:

{
  networking = {
    extraHosts = 
      " 
      127.0.0.1 nab-admin-dev.neosoft.ba 
      127.0.0.1 rockmongo.nab-solutions.com 
      127.0.0.1 pma 
      127.0.0.1 admin-service-dev.nab-solutions.com 
      127.0.0.1 ngs.nab-solutions.com 
      127.0.0.1 tax-local.7platform.com 
      127.0.0.1 transaction-archive-local.7platform.com 
      127.0.0.1 localadmin.7platform.com  
      127.0.0.1 accounts-local.7platform.com  
      127.0.0.1 loyalty-api-local.7platform.com 
      127.0.0.1 devportal-local.7platform.com 
      127.0.0.1 devportal-api-local.7platform.com 
      127.0.0.1 bhq-local.7platform.com
      127.0.0.1 catalog-local.7platform.com
      ";
  };

  environment.systemPackages = with pkgs; [
    arcanist
    lastpass-cli
    openvpn
    python27Packages.docker_compose 
  ];

  users.extraUsers.boris = {
    extraGroups = [ "docker" ];
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };

}
