{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        jetbrains.datagrip
        _1password
        heroku
        postgresql_10
        gnupg
        google-cloud-sdk
        zoom-us
    ];
    programs.gnupg.agent.enable = true;

}
