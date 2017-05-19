# Edit this configuration file to define what should be installed on

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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
      127.0.0.1 accounts-local.7platform.com  # NSOFT
      /*172.20.16.49 jenkins.nsoft.ba # NSOFT*/
      /*172.20.16.98 pma.nsoft.com # NSOFT NEW AS OF 2016-12-07*/
      #172.20.115.1 pma.nsoft.com # NSOFT  OLD - NOT WORKING
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
    file
    wget
    vimHugeX
    neovim
    nox
    #awesome-3-5
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

    xdg_utils

    rsync
    traceroute

    atom

    /*python27Packages.sqlite3*/
    /*python27Packages.sqlite3*/
    /*python27Packages.pysqlite*/

    python35Packages.youtube-dl

    kdeApplications.kdenetwork-filesharing
    kdeApplications.dolphin-plugins
    kdeFrameworks.kcmutils
    /*kdeApplications.breeze*/
    kdeFrameworks.karchive
    kdeApplications.spectacle
    kdeFrameworks.karchive
    kdeApplications.ark
    kdeApplications.okular


    #kdeApplications.kmail


    pidgin

    unrar
    vlc
    gimp

    sshfs-fuse
    

    playonlinux
    winetricks
    wineStaging
    openldap #test for wine and hearthstone

    nmap

    usbutils #lsusb and co

    cloc 
    xtrlock-pam

    cpufrequtils

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

    slack

    qmmp

    #clang don't thin it is necessary

    kodi

    hdparm

    imagemagickBig

    dmenu

    lshw

    wmctrl

    multitail
    beets

    kdeApplications.kate

    #DVD
    libdvdread
    dvdplusrwtools
    dvdbackup

    kdeApplications.gwenview
    bluedevil

    lxqt.pcmanfm-qt

    win-qemu

    rxvt_unicode

    handbrake
    vobcopy
    k9copy
  

    openvpn #NSOFT

    #XMONAD
    #haskellPackages.xmobar

    evtest #inupt event debugging, like touchpad values

    acpi
    openjdk #for phpstorm
  
    xorg.xev # 

    lastpass-cli

    kdeApplications.kcachegrind

    idea.idea-community

    scrot

    kdeconnect

    patchelf

    scala

      ]; # ++ builtins.filter stdenv.lib.isDerivation (builtins.attrValues plasma5_latest);
# List services that you want to enable:

# Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.unclutter = {
    enable = true;
    package = pkgs.unclutter-xfixes;
  };


# Enable CUPS to print documents.
# services.printing.enable = true;

# Enable the X11 windowing system.
  /*services.dbus = {*/
    /*packages = [ pkgs.bluez5 ];*/
  /*};*/
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:escape";
    /*displayManager.sddm.enable = true;*/
    displayManager.slim.enable = true;
    displayManager.slim.defaultUser = "boris";
    desktopManager.plasma5.enable = true;
    #desktopManager.lxqt.enable = true;
    windowManager.awesome = {
      enable = true;
      package = pkgs.awesome-3-5;
    };
    windowManager.xmonad = {
      enableContribAndExtras = true;
      enable = true;
    };
#windowManager.i3.enable = true;
#windowManager.bspwm.enable = true;
    synaptics = {
      accelFactor = "0.4";
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
/*  services.mopidy = {
    enable = false;
    dataDir = "/home/mopidy/";
    extensionPackages = [ pkgs.mopidy-youtube pkgs.mopidy-mopify pkgs.mopidy-moped ];
    configuration = ''
      [local]
      media_dir = /home/boris/Media/Music/
        scan_follow_symlinks = true
        '';
  };*/
#services.plex = {
#enable = true;
#dataDir = "/home/boris/dirty/plex";
#};

#Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.boris = {
    isNormalUser = true;
    extraGroups = [ 
	"wheel" 
	"networkmanager" 
	"docker" #DOCKER IS FOR NSOFT
        "libvirtd"
    ]; 
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
  };

# The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

  /*services.thermald.enable = true;*/
  /*services.thinkfan.enable = true;*/


  programs = {
    zsh.enable = true;
  };
  hardware = {
    trackpoint.enable = true;
    pulseaudio = {
      package = pkgs.pulseaudioFull; #for bluetooth, i think
      enable = true;
      support32Bit = true;
    };
    bluetooth.enable = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

    /*sane = {*/
      /*enable = true;*/
      /*extraBackends = [ pkgs.hplipWithPlugin];*/
    /*};*/
  };
  services.tlp.enable = true;
  services.locate = {
    enable = true;
    interval = "hourly";
    localuser = "root";
  };

  powerManagement = {
    enable = true;
  };

  virtualisation.virtualbox = {
    host.enable =  true;
  };
  /*virtualisation.libvirtd = {*/
    /*enable = true;*/
    /*enableKVM = true;*/
  /*};*/
  virtualisation.docker = { #NSOFT
    enable = true;
    storageDriver = "overlay2";
  };
  nixpkgs.config = {
    allowUnfree = true; 
    wine = {
      release = "staging"; # "stable", "unstable", "staging"
      #build = "wine32"; # "wine32", "wine64", "wineWow"
      #pulseaudioSupport = true;
    };
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
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
