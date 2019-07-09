{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        jetbrains.datagrip
        _1password
        heroku
        postgresql_10
        gnupg
        google-cloud-sdk
    ];
    programs.gnupg.agent.enable = true;

}
