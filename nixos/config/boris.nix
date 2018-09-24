
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
  ]; 
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];
  home-manager.users.boris = {
    programs.git = {
      enable = true;
      userName = "Boris Babic";
      userEmail = "boris.ivan.babic@gmail.com";
      ignores = [
        "*.sw[a-z]"
        "\.idea/"
      ];
      aliases = {
        chekcout = "checkout";
        co = "checkout";
      };
      extraConfig=''
        [init]
            templateDir = ~/.git_template
      '';
    };
  };
}
