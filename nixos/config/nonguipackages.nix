{ config, pkgs, ... }:
let 
  languages = with pkgs; [

    jre
    nodejs-8_x
    openjdk
    php
    python
    python36Full
    ruby
    scala

  ];
  goPkgs = with pkgs; [
    go
    glide #package manager
    godep
  ];
  phpPkgs = with pkgs; [
    php71Packages.xdebug
    php71Packages.composer
  ];
  nodePkgs = with pkgs; [

    nodePackages.bower
    nodePackages.grunt-cli
    nodePackages.typescript

  ];

  pythonPkgs = with pkgs; [
    python27Packages.pip
    python27Packages.pyyaml
    python36Packages.pip
    python36Packages.setuptools
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
    aspell #spellcheck, usefull with emacs
    aspellDicts.en
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

  ] ++ languages ++ phpPkgs ++ nodePkgs ++ pythonPkgs ++ gstreamerPlugins ++ goPkgs ++ [];
}

