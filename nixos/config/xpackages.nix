{ config, pkgs, ... }:
let 
  browsers = with pkgs; [

     google-chrome #netflix
    # chromium
    # firefox
    # opera

  ];
  terminals = with pkgs; [

    # enlightenment.terminology
    # rxvt_unicode
    terminator
    # termite

  ];
  editors = with pkgs; [

    vscode
    #atom
    # vimHugeX

  ];
  media = with pkgs; [

    #clementine
    vlc

  ];
  utilities = with pkgs; [

    # arandr
    bluedevil
    # flameshot # screenshot
    # hplip TEMP
    # lxqt.pcmanfm-qt
    # pavucontrol
    # scrot # screenshot
    # simple-scan
    wmctrl
    xbindkeys # for stuff in ~/.xbindkeys used for awesomewm
    xclip
    # xscreensaver
    # uses old python
    # xtrlock-pam

  ];
  wineStuff = with pkgs; [

    #playonlinux
    #(wineWowPackages.staging.override { vulkanSupport = true; vkd3dSupport = true; })
    # wineWowPackages.staging
    #winetricks
    #xorg_sys_opengl #for playonlinux

  ];

in 
{
  environment.systemPackages = with pkgs; if config.services.xserver.enable then [

    # calibre TEMP
    deluge
    # gimp
    # libreoffice
    # pidgin
    # slack
    # transmission-remote-gtk

  ] ++ browsers ++ terminals ++ editors ++ media ++ utilities else [];#++ wineStuff else [];
  nixpkgs.config = {
    firefox = {
      /*enableAdobeFlash = true;*/
      #enableAdobeFlash = false;
    };
  };
}
