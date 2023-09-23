# Edit this configuration file to define what should be installed on

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
  #master-nixpkgs = import (pkgs.fetchFromGitHub {
    #owner = "nixos";
    #repo = "nixpkgs";
    #rev = "006a699e693da92bc9f31775a7e0825a33a5063c";
    #sha256 = "107zlpwiqarpn4klmklrps28b77k9azqiax3vvf584zh60ccwpjv";
  #}) {
    #config.allowUnfree = true;
  #};
  openPorts = [
    5900 # virtscreen vnc
  ];
  openPortRanges = [
    { from = 1714; to = 1764; }
  ];
in {
  environment.systemPackages = with pkgs; [
    #for testing stuff, otherwise put it in an import

    vokoscreen #screencast
    barrier

    pandoc #document converter
    #tetex #used with pandoc for creating pdfs
    #texlive.combined.scheme-full #pandoc
    texlive.combined.scheme-small

    dict

    #thefuck
    #jetbrains.idea-ultimate
    #jetbrains.idea-community
    gradle
    maven
    yarn #node pacakge manager
    nomad
    shellcheck
    jshon
    vimPlugins.Jenkinsfile-vim-syntax
    thefuck
    # viber
    openvpn
    postman
    docker-compose
    gitAndTools.pre-commit
    miraclecast
    #steam
    obs-studio
    ngrok
    jq
    skypeforlinux
    discord
    #virtscreen
    #arandr # for use with virtscreen
    hexchat
    google-chrome-beta
    transmission-gtk

    et # very simple timer

    numix-gtk-theme
    numix-sx-gtk-theme
    numix-icon-theme
    numix-cursor-theme
    steam

    neofetch
    tdesktop
    ntfs3g
    #pulseaudio-dlna NOT BUILDING
    silver-searcher
    ripgrep
    winetricks
    protontricks
    #soundwire

   microsoft-edge
    unzip
    gnumake
    stylua
    screen
    lazygit
    dbeaver
    copyq
  ];
  imports =
    [
        ./kde.nix
        ./xorg.nix
        ./nonguipackages.nix
        ./xpackages.nix
        ./custom_packages/njuskalo-service.nix
        ./direnv.nix
        ./hyprland.nix
        #./boris.nix
    ];

  networking = {
    hostName = "nixos"; # Define your hostname.
#wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    firewall.allowedUDPPorts = openPorts;
    firewall.allowedTCPPorts = openPorts;
    firewall.allowedUDPPortRanges = openPortRanges;
    firewall.allowedTCPPortRanges = openPortRanges;
    nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4" "9.9.9.9"];
  };

  hardware.opengl.driSupport32Bit = true; # for steam
  hardware.pulseaudio.support32Bit = true; # for steam

  #console.font = "Lat2-Terminus16";
# Select internationalisation properties.
  # i18n = {
    # consoleFont = "Lat2-Terminus16";
#   consoleKeyMap = "us";
#   defaultLocale = "en_US.UTF-8";
  # };

# Set your time zone.
  time.timeZone = "Europe/Sarajevo";


# Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.sonarr.enable = true;
  users.extraUsers.sonarr.extraGroups = [ "transmission" ];
  services.radarr.enable = true;
  users.extraUsers.radarr.extraGroups = [ "transmission" ];
  services.transmission = {
    enable = true;
    settings = {
      rpc-whitelist = "127.0.0.1";
    };
  };

  services.ratbagd.enable = true;
  #services.unclutter = {
    #enable = true;
    #package = pkgs.unclutter-xfixes;
  #};

#Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.boris = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
      "libvirtd"
      "sonarr"
      "transmission"
      "docker"
      "video" # for brightness
      "input" # keyboard backlight
      "adbusers"
    ]; 
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };

  programs = {
    mtr.enable = true;
    zsh.enable = true;
    java = {
      enable = true;
    };
  };
  services.locate = {
    enable = true;
    interval = "hourly";
    localuser = "root";
  };
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [ pkgs.gutenprintBin ];
  services.njuskalo = {
    enable = false;
    email.username = "novaplatforma@gmail.com";
    email.password = secrets.novaplatformaPassword;
    email.recipient = "boris.ivan.babic@gmail.com";
    urls = {
      switchRabljeno700Do1400 = "https://www.njuskalo.hr/nintendo-switch?locationIds=1153&price[min]=700&price[max]=1400&condition[new]=1&condition[used]=1";
    };
  };

  #virtualisation.virtualbox = {
    #host.enable =  true;
  #};
  /*virtualisation.libvirtd = {*/
    /*enable = true;*/
    /*enableKVM = true;*/
  /*};*/
  nixpkgs.config = {
    allowUnfree = true; 
    /*chromium = {*/
      /*enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash*/
    /*};*/
  };
  fonts = {
    fonts = [ pkgs.powerline-fonts pkgs.terminus_font pkgs.roboto pkgs.roboto-slab pkgs.emojione ];
    fontconfig = {
      defaultFonts = {
        monospace = ["Source Code Pro for Powerline" "Roboto Mono for Powerline"];
        sansSerif = ["Roboto"];
        serif = ["Roboto Slab"];
      };
    };
  };
  # programs.qt5ct.enable = true;
  programs.command-not-found.enable = true;

   nixpkgs.config.permittedInsecurePackages = [
    "samba-3.6.25"
    "p7zip-16.02"
   ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 11;
  };
  /*nixpkgs.config.packageOverrides = pkgs: {*/
    /*maven = pkgs.maven.override { jdk = pkgs.jdk9; };*/
  /*};*/
  nix.nixPath = [
    "nixpkgs=/etc/nixos/nixpkgs/"
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs-overlays=/etc/nixos/config/overlays-compat/" # https://nixos.wiki/wiki/Overlays#Using_nixpkgs.overlays_from_configuration.nix_as_.3Cnixpkgs-overlays.3E_in_your_NIX_PATH
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.tmp.cleanOnBoot = true;

  networking.extraHosts =
    ''
      157.90.156.81 dokku
    '';
}
