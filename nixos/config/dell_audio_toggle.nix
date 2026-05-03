# Created with some help from gemini
# https://gemini.google.com/app/3e13414000bc8f9a

{ config, pkgs, ... }:

let
  headset-switcher = pkgs.writers.writePython3 "headset-switcher" { doCheck = false; } (builtins.readFile ./dell_audio_toggle.py);
in
{
  systemd.user.services.alienware-switcher = {
    description = "Alienware Headset Audio Switcher";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ pkgs.libnotify pkgs.wireplumber ];
    serviceConfig = {
      ExecStart = "${headset-switcher}";
      Restart = "always";
      RestartSec = 3;
    };
  };
}
