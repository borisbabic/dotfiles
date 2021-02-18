{ config, pkgs, ... }:
let 
  browsers = with pkgs; [

    google-chrome #netflix
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

    vscode
    atom
    vimHugeX

  ];
  media = with pkgs; [

    clementine
    vlc

  ];
  utilities = with pkgs; [

    arandr
    bluedevil
    flameshot # screenshot
    # hplip TEMP
    lxqt.pcmanfm-qt
    pavucontrol
    scrot # screenshot
    simple-scan
    wmctrl
    xbindkeys # for stuff in ~/.xbindkeys used for awesomewm
    xclip
    xfce.thunar
    xscreensaver
    xtrlock-pam

  ];
  wineStuff = with pkgs; [

    #playonlinux
    #(wineWowPackages.staging.override { vulkanSupport = true; vkd3dSupport = true; })
    wineWowPackages.staging
    winetricks
    #xorg_sys_opengl #for playonlinux

  ];

in 
{
  environment.systemPackages = with pkgs; if config.services.xserver.enable then [

    # calibre TEMP
    deluge
    gimp
    libreoffice
    pidgin
    slack
    transmission_remote_gtk

  ] ++ browsers ++ terminals ++ editors ++ media ++ utilities ++ wineStuff else [];
  nixpkgs.config = {
    firefox = {
      /*enableAdobeFlash = true;*/
      enableAdobeFlash = false;
    };
  };
}
