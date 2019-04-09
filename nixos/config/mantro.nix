{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        jetbrains.datagrip
        _1password
        heroku
        postgresql_10
        gnupg
    ];
    programs.gnupg.agent.enable = true;

}
