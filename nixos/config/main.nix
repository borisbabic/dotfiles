# Edit this configuration file to define what should be installed on

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
        ./nsoft.nix
        ./node.nix
        ./php.nix
        ./kde.nix
        ./xorg.nix
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
    tmux
    emacs
    htop
    xscreensaver
    parted
    dropbox # for syncing
    xbindkeys # for stuff in ~/.xbindkeys used for awesomewm
    inotify-tools
    gcc
    transmission_gtk
    transmission_remote_gtk
    pavucontrol
    ruby
    p7zip
    sqlite

    rsync
    traceroute

    atom

    python35Packages.youtube-dl



    enlightenment.terminology

    termite

    pidgin

    unrar
    vlc
    gimp

    sshfs-fuse
    

    xorg_sys_opengl #for playonlinux
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


    glxinfo

    #DVD
    libdvdread
    dvdplusrwtools
    dvdbackup

    bluedevil

    lxqt.pcmanfm-qt

    win-qemu

    rxvt_unicode

    handbrake
    vobcopy
    k9copy
  

    #XMONAD
    #haskellPackages.xmobar

    evtest #inupt event debugging, like touchpad values

    acpi
    openjdk #for phpstorm
  

    lastpass-cli


    idea.idea-community

    scrot


    patchelf

    scala

    opera

    /*hplip_3_15_9*/
    hplip

      ]; 

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
