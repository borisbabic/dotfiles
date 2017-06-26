{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs
    nodePackages.typescript
    nodePackages.grunt-cli
    nodePackages.bower
  ];
}
