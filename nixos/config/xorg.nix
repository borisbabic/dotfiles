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
        version = "git-20190825-f1335be2";
        src = super.fetchFromGitHub {
          owner = "awesomeWM";
          repo = "awesome";
          rev = "f1335be21ad0cbca90c63d9a25982904b966ac65";
          sha256 = "1v5d4cx1jbhfk5zdccmvcaiypsly607s1ydf80y3hl5iyilnrh3n";
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
    windowManager.awesome = {
      enable = true;
      package = pkgs.awesome-git;
      #package = pkgs.callPackage ./custom_packages/awesome3.5.nix {
        #cairo = pkgs.cairo.override { xcbSupport = true; };
      #};
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      /*package = pkgs.i3;*/
    };
  };
}

