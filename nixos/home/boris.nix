
{ config, pkgs, ... }:
{
  home.stateVersion = "25.11"; # Did you read the comment?
  services.arrpc = {
    enable = true;
  };
}
