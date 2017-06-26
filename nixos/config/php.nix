{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    php
    php71Packages.xdebug
    phpPackages.phpcs
  ];
}

