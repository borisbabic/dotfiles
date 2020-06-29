{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg_utils
    xorg.xev # 
    xorg.xkill
    #compton
  ];


  nixpkgs.overlays = [
    (self: super: {
      awesome-git = super.awesome.overrideAttrs (old: rec {
        name = "awesome-git";
        version = "git-20191019-0297bff"; # last checked 2019-11-06
        src = super.fetchFromGitHub {
          owner = "awesomeWM";
          repo = "awesome";
          rev = "0297bfff9ad88535fd9302fdb7d9b11459d6b1b4";
          sha256 = "1ss272n0k65chjg9m4yfyzljm60gga5p1dw97lqfw5i4kbsgi80r";
        };
      });
    })
  ];
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:escape";
    displayManager.sddm.enable = true;
    /*displayManager.slim.defaultUser = "boris";*/
    #displayManager.slim.enable = true;
    #displayManager.slim.defaultUser = "boris";
    #desktopManager.pantheon.enable = true;
    #desktopManager.xfce.enable = true;
    #desktopManager.mate.enable = true;
    #desktopManager.gnome3.enable = true;
    #desktopManager.lumina.enable = true;
    # desktopManager.pantheon.enable = true;
    windowManager.awesome = {
      enable = true;
      # package = pkgs.awesome-git;
      #package = pkgs.callPackage ./custom_packages/awesome3.5.nix {
        #cairo = pkgs.cairo.override { xcbSupport = true; };
      #};
    };
    #windowManager.i3 = {
      #enable = true;
      #package = pkgs.i3-gaps;
      /*package = pkgs.i3;*/
    #};
  };
}

