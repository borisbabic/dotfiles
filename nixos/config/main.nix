# Edit this configuration file to define what should be installed on

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
        ./nsoft.nix
        ./kde.nix
        ./xorg.nix
        ./nonguipackages.nix
        ./xpackages.nix
    ];

  boot.loader.grub = pkgs.lib.mkForce {
	  enable = true;
	  version = 2;
	  device = "/dev/sda";
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
#wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
  };

# Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
#   consoleKeyMap = "us";
#   defaultLocale = "en_US.UTF-8";
  };

# Set your time zone.
  time.timeZone = "Europe/Sarajevo";


# Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.unclutter = {
    enable = true;
    package = pkgs.unclutter-xfixes;
  };

#Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.boris = {
    isNormalUser = true;
    extraGroups = [ 
	"wheel" 
	"networkmanager" 
        "libvirtd"
    ]; 
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
  };

# The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";



  programs = {
    zsh.enable = true;
  };
  services.tlp.enable = true;
  services.locate = {
    enable = true;
    interval = "hourly";
    localuser = "root";
  };
  services.printing.enable = true;

  virtualisation.virtualbox = {
    host.enable =  true;
  };
  /*virtualisation.libvirtd = {*/
    /*enable = true;*/
    /*enableKVM = true;*/
  /*};*/
  nixpkgs.config = {
    allowUnfree = true; 
    wine = {
      release = "staging"; # "stable", "unstable", "staging"
      #build = "wine32"; # "wine32", "wine64", "wineWow"
      #pulseaudioSupport = true;
    };
    firefox = {
      enableAdobeFlash = true;
    };
    /*chromium = {*/
      /*enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash*/
    /*};*/
  };
  fonts = {
    fonts = [ pkgs.powerline-fonts pkgs.terminus_font pkgs.roboto pkgs.roboto-slab ];
    fontconfig = {
      defaultFonts = {
        monospace = ["Source Code Pro for Powerline" "Roboto Mono for Powerline"];
        sansSerif = ["Roboto"];
        serif = ["Roboto Slab"];
      };
    };
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 11;
  };
}
