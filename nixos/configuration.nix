# Edit this configuration file to define what should be installed on

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
# Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking = {
    hostName = "nixos"; # Define your hostname.
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    extraHosts = 
      " 
127.0.0.1 nab-admin-dev.neosoft.ba # NSOFT
127.0.0.1 rockmongo.nab-solutions.com # NSOFT
127.0.0.1 pma # NSOFT
127.0.0.1 admin-service-dev.nab-solutions.com # NSOFT
127.0.0.1 ngs.nab-solutions.com # NSOFT
127.0.0.1 tax-local.7platform.com # NSOFT
127.0.0.1 transaction-archive-local.7platform.com # NSOFT
127.0.0.1 localadmin.7platform.com  # NSOFT
127.0.0.1 localadmin.7platform.com  # NSOFT
172.20.115.1 pma-main.pma.nsoft.com pma-bb pma-rom pma-staging #pma.nsoft.com

      ";
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Sarajevo";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
   environment.systemPackages = with pkgs; [
     wget
     vimHugeX
     neovim
     nox
     awesome
     firefox
     chromium
     shared_mime_info
     jre
     fzf
     coreutils
     which
     zsh
     terminator
     python
     python27Packages.pip
     python27Packages.pyyaml
     python3
     git
     python27Packages.docker_compose #NSOFT
     nodejs
     php
     xorg.xf86inputsynaptics #touchpad
     tmux
     emacs
     htop
     xscreensaver
     nodePackages.grunt-cli
     nodePackages.bower
     nodePackages.typescript #for nsoft/
     parted
     dropbox # for syncing
     xbindkeys # for stuff in ~/.xbindkeys used for awesomewm
     inotify-tools
     gcc
     phpPackages.phpcs
     transmission_gtk
     transmission_remote_gtk
     pavucontrol
     ruby
     xorg.xkill
     xorg.xbacklight
     p7zip
     sqlite
     xorg_sys_opengl #for playonlinux

     powerline-fonts #for agnoster, doesn't work
     terminus_font

     rsync
     
     atom

     python27Packages.sqlite3
     python27Packages.pysqlite

     python35Packages.youtube-dl

     kde5.kdenetwork-filesharing
     kde5.dolphin-plugins
     kde5.kcmutils
     kde5.breeze
     kde5.karchive
     kde5.spectacle
     kde5.karchive
     kde5.ark
     #kde5.kmail
     qt5.telepathy
     qt5.accounts-qt

     pidgin

     unrar
     vlc
     gimp

     playonlinux
     winetricks
     wineUnstable
     openldap #test for wine and hearthstone

     nmap

     usbutils #lsusb and co

     cloc 
     xtrlock-pam

     stow
     calibre
     mtr
     xclip
     speedtest-cli
     dmidecode
     upower

     libreoffice

     stress
     steam

     exfat

     xfce.thunar

     simple-scan

     #mopidy-moped
     #mopidy-mopify
     #mopidy-youtube
     
     clementine

     #gstreamer plugins
     gst_plugins_bad
     gst_plugins_base
     gst_plugins_good
     gst_plugins_ugly

     clang

     kodi
     byobu

     imagemagickBig

     dmenu
     
     lshw

     wmctrl

     multitail

     kde5.kate

     #DVD
     libdvdread
     dvdplusrwtools

     kde5.gwenview
	
     


     rxvt_unicode

     openvpn #NSOFT

	#XMONAD
    #haskellPackages.xmobar
    #stalonetray

     evtest #inupt event debugging, like touchpad values

   
   ]; # ++ builtins.filter stdenv.lib.isDerivation (builtins.attrValues plasma5_latest);
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:escape";
    displayManager.sddm.enable = true;
    desktopManager.kde5.enable = true;
    windowManager.awesome.enable = true;
    windowManager.xmonad = {
       enableContribAndExtras = true;
       enable = true;
    };
    #windowManager.i3.enable = true;
    #windowManager.bspwm.enable = true;
    synaptics = {
        accelFactor = "0.2";
        enable = true;
        horizEdgeScroll = true;
        palmDetect = true;
        palmMinWidth = 5;
        palmMinZ = 20;
        tapButtons = true;
        vertTwoFingerScroll = true;
        vertEdgeScroll = true;
	buttonsMap = [ 1 3 2 ];
	fingersMap = [ 1 2 3 ];
    };
  };
  services.mopidy = {
    enable = true;
    dataDir = "/home/mopidy/";
    extensionPackages = [ pkgs.mopidy-youtube pkgs.mopidy-mopify pkgs.mopidy-moped ];
    configuration = ''
[local]
media_dir = /home/boris/Media/Music/
scan_follow_symlinks = true
'';
  };
  #services.plex = {
    #enable = true;
    #dataDir = "/home/boris/dirty/plex";
  #};

  #Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.boris = {
	  isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" "docker" ]; #DOCKER IS FOR NSOFT
	  uid = 1000;
          shell = "/run/current-system/sw/bin/zsh";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

  services.thermald.enable = true;
  #services.thinkfan.enable = true;


  hardware = {
    trackpoint.enable = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

    sane = {
       enable = true;
       extraBackends = [ pkgs.hplipWithPlugin];
    };
  };
  services.tlp.enable = true;

  virtualisation.virtualbox = {
    host.enable =  true;
  };
  virtualisation.docker = { #NSOFT
    enable = true;
  };
  nixpkgs.config = {
	  allowUnfree = true; 
	  chromium = {
		  enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash
	  };
  };
  fonts.fontconfig.defaultFonts.monospace = ["Terminus"];

  boot.kernel.sysctl = {
	"vm.swappiness" = 10;
  };

}
