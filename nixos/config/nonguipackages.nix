{ config, pkgs, ... }:
let 
  languages = with pkgs; [
    elixir
    jre
    nodejs-10_x
    php
    python
    python36Full
    ruby
    scala
  ];
  elmPkgs = with pkgs.elmPackages; [
    elm
    elm-format
  ];
  haskellPkgs = with pkgs; [
    ghc
  ];
  goPkgs = with pkgs; [
    go
    glide #package manager
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
  luaPkgs = with pkgs.lua52Packages; [
    lua
    luacheck
  ];
  gstreamerPlugins = with pkgs; [

    gst_plugins_bad
    gst_plugins_base
    gst_plugins_good
    gst_plugins_ugly

  ];
 
in 
{
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [

    #beets
    bat # better cat
    cloc 
    coreutils
    cpufrequtils
    emacs
    evtest #inupt event debugging, like touchpad values
    exa # better ls
    exfat

    #   _                      _            _     _       _          _   _     _     
    #  | |_ _   _ _ __ _ __   | |_ _____  _| |_  (_)_ __ | |_ ___   | |_| |__ (_)___ 
    #  | __| | | | '__| '_ \  | __/ _ \ \/ / __| | | '_ \| __/ _ \  | __| '_ \| / __|
    #  | |_| |_| | |  | | | | | ||  __/>  <| |_  | | | | | || (_) | | |_| | | | \__ \
    #   \__|\__,_|_|  |_| |_|  \__\___/_/\_\\__| |_|_| |_|\__\___/   \__|_| |_|_|___/
    figlet # see above
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
    lolcat # fabulously color output
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

  ] ++ languages ++ nodePkgs ++ pythonPkgs ++ gstreamerPlugins ++ goPkgs ++ haskellPkgs ++ elmPkgs ++ luaPkgs ++ [] ;
}

