{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        jetbrains.datagrip
        _1password
        heroku
        postgresql
    ];

}
