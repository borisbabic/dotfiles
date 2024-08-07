{ config, pkgs, ... }:
let 
  languages = with pkgs; [
    erlang
    elixir
    jre
    nodejs
    php
    python3Full
    ruby
    scala
    go
  ];
  nodePkgs = with pkgs; [
    #nodePackages.bower
    nodePackages.grunt-cli
  ];

  pythonPkgs = with pkgs; [
    python3Packages.pip
    python3Packages.setuptools
    python3Packages.twine # for publishing/updating packages: twine upload dist/*
    python3Packages.pylint
    # python3Packages.autopep8
  ];
  luaPkgs = with pkgs.luaPackages; [
    lua
    luacheck
  ];
  # gstreamerPlugins = with pkgs.gst_all_1; [
  #   gst-plugins-bad
  #   gst-plugins-base #removed?
  #   gst-plugins-good
  #   gst-plugins-ugly
  #
  # ];
 
in 
{
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [

    #beets
    bat # better cat
    cloc 
    coreutils
    cpufrequtils
    # emacs
    eza # better ls
    exfat
    expect # provides unbuffer which allows you to do something like `unbuffer command | tee file` and preserve color

    fd # find alternative
    #   _                      _            _     _       _          _   _     _     
    #  | |_ _   _ _ __ _ __   | |_ _____  _| |_  (_)_ __ | |_ ___   | |_| |__ (_)___ 
    #  | __| | | | '__| '_ \  | __/ _ \ \/ / __| | | '_ \| __/ _ \  | __| '_ \| / __|
    #  | |_| |_| | |  | | | | | ||  __/>  <| |_  | | | | | || (_) | | |_| | | | \__ \
    #   \__|\__,_|_|  |_| |_|  \__\___/_/\_\\__| |_|_| |_|\__\___/   \__|_| |_|_|___/
    # figlet # see above
    file
    fzf #fuzzy search
    # gcc
    git
    glances # monitoring, shows more stuff than htop
    hdparm
    htop
    inotify-tools
    # aspell #spellcheck, usefull with emacs
    # aspellDicts.en
    lshw
    lolcat # fabulously color output
    multitail
    ncdu # du cli browser
    neovim
    nmap
    # nox
    # p7zip abandoned
    parted
    # patchelf
    # pwgen # generate password
    rsync
    shared-mime-info
    speedtest-cli
    sqlite
    sshfs-fuse
    stow
    # stress # stress test
    tmux
    traceroute
    upower
    usbutils #lsusb and co
    wget
    which
    zsh


    pgcli

    gnupg
    # postgresql
  ] ++ languages ++ nodePkgs ++ pythonPkgs ++ luaPkgs ++ [] ;
  services.atd.enable = true;
}

