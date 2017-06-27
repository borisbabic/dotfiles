{ config, pkgs, ... }:
let 
  languages = with pkgs; [

    jre #java
    nodejs
    openjdk #java
    php
    python
    python3
    ruby
    scala

  ];
  phpPkgs = with pkgs; [
    php71Packages.xdebug
    phpPackages.phpcs
  ];
  nodePkgs = with pkgs; [

    nodePackages.bower
    nodePackages.grunt-cli
    nodePackages.typescript

  ];

  pythonPkgs = with pkgs; [

    python27Packages.pip
    python27Packages.pyyaml

  ];
  gstreamerPlugins = with pkgs; [

    gst_plugins_bad
    gst_plugins_base
    gst_plugins_good
    gst_plugins_ugly

  ];
 
in 
{
  environment.systemPackages = with pkgs; [

    acpi
    beets
    cloc 
    coreutils
    cpufrequtils
    emacs
    evtest #inupt event debugging, like touchpad values
    exfat
    file
    fzf #fuzzy search
    gcc
    git
    hdparm
    htop
    imagemagickBig
    inotify-tools
    lshw
    mtr
    multitail
    neovim
    nmap
    nox
    p7zip
    parted
    patchelf
    python35Packages.youtube-dl
    rsync
    shared_mime_info
    speedtest-cli
    sqlite
    sshfs-fuse
    stow
    stress
    tmux
    traceroute
    unrar
    upower
    usbutils #lsusb and co
    wget
    which
    zsh

  ] ++ languages ++ phpPkgs ++ nodePkgs ++ pythonPkgs ++ gstreamerPlugins ++ [];
}

