{ config, pkgs, ... }:
let 
  languages = with pkgs; [

    jre
    nodejs-10_x
    php
    python
    python36Full
    ruby
    scala
  ];
  haskellPkgs = with pkgs; [
    ghc
  ];
  goPkgs = with pkgs; [
    go
    glide #package manager
  ];
  phpExtensions = with pkgs; [
    "${php72Packages.redis}/lib/php/extensions/redis.so"
  ];
  phpPkgs = with pkgs; [
    php72Packages.xdebug
    php71Packages.composer
  ];
  nodePkgs = with pkgs; [

    nodePackages.bower
    nodePackages.grunt-cli

  ];

  pythonPkgs = with pkgs; [
    python2Packages.pip
    python2Packages.pyyaml
    python3Packages.pip
    python3Packages.setuptools
    python3Packages.twine # for publishing/updating packages: twine upload dist/*
  ];
  gstreamerPlugins = with pkgs; [

    gst_plugins_bad
    gst_plugins_base
    gst_plugins_good
    gst_plugins_ugly

  ];
 
in 
{
  nixpkgs.config.phpOptions.extension = phpExtensions;
  nixpkgs.config.enablePHP = true;
  services.phpfpm.phpOptions = ''
    extension=${pkgs.phpPackages.redis}/lib/php/extensions/redis.so
  '';
  environment.systemPackages = with pkgs; [

    #beets
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
    multitail
    neovim
    nmap
    nox
    p7zip
    parted
    patchelf
    python3Packages.youtube-dl
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

  ] ++ languages ++ phpPkgs ++ nodePkgs ++ pythonPkgs ++ gstreamerPlugins ++ goPkgs ++ haskellPkgs ++ [] ;
}

