{ config, pkgs, ... }:
let 
  browsers = with pkgs; [

    chromium
    firefox
    opera

  ];
  terminals = with pkgs; [

    enlightenment.terminology
    rxvt_unicode
    terminator
    termite

  ];
  editors = with pkgs; [

    atom
    vimHugeX

  ];
  media = with pkgs; [

    clementine
    kodi
    vlc

  ];
  utilities = with pkgs; [

    bluedevil
    dropbox # for syncing
    hplip
    lxqt.pcmanfm-qt
    pavucontrol
    scrot
    simple-scan
    wmctrl
    xbindkeys # for stuff in ~/.xbindkeys used for awesomewm
    xclip
    xfce.thunar
    xscreensaver
    xtrlock-pam

  ];
  wineStuff = with pkgs; [

    openldap #test for wine and hearthstone
    playonlinux
    wineStaging
    winetricks
    xorg_sys_opengl #for playonlinux

  ];

in 
{
  environment.systemPackages = with pkgs; if config.services.xserver.enable then [

    calibre
    gimp
    krita
    libreoffice
    pidgin
    slack
    steam
    transmission_gtk
    transmission_remote_gtk

  ] ++ browsers ++ terminals ++ editors ++ media ++ utilities ++ wineStuff else [];
}
