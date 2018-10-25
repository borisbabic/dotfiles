# Edit this configuration file to define what should be installed on

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
in {
  environment.systemPackages = with pkgs; [
    #for testing stuff, otherwise put it in an import

    vokoscreen #screencast

    pandoc #document converter
    #tetex #used with pandoc for creating pdfs
    #texlive.combined.scheme-full #pandoc
    texlive.combined.scheme-small

    stack

    #thefuck
    jetbrains.idea-ultimate
    gradle
    maven
    /*elmPackages.elm*/
    /*elmPackages.elm-package*/
    /*elmPackages.elm-format*/
    yarn #node pacakge manager
    nomad
    shellcheck
    jshon
    vimPlugins.Jenkinsfile-vim-syntax
    thefuck
    viber
    openvpn
    postman
    docker_compose
    gitAndTools.pre-commit
  ];
  imports =
    [
        ./kde.nix
        ./xorg.nix
        ./nonguipackages.nix
        ./xpackages.nix
        ./custom_packages/njuskalo-service.nix
    ];

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
      "sonarr"
      "transmission"
      "docker"
    ]; 
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };

  programs = {
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
  services.printing.drivers = [pkgs.gutenprintBin];
  services.njuskalo = {
    enable = true;
    email.username = "novaplatforma@gmail.com";
    email.password = secrets.novaplatformaPassword;
    email.recipient = "boris.ivan.babic@gmail.com";
    urls = {
      stanNajamDonji = "http://www.njuskalo.hr/iznajmljivanje-stanova?locationId=1250&price[max]=500";
      stanNajamPesenica = "http://www.njuskalo.hr/iznajmljivanje-stanova?locationId=1256&price[max]=500";
      stanNajamTrnje = "http://www.njuskalo.hr/iznajmljivanje-stanova?locationId=1263&price[max]=500";
    };
  };

  virtualisation.virtualbox = {
    host.enable =  true;
  };
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
    fonts = [ pkgs.powerline-fonts pkgs.terminus_font pkgs.roboto pkgs.roboto-slab ];
    fontconfig = {
      defaultFonts = {
        monospace = ["Source Code Pro for Powerline" "Roboto Mono for Powerline"];
        sansSerif = ["Roboto"];
        serif = ["Roboto Slab"];
      };
    };
  };
  programs.qt5ct.enable = true;

   nixpkgs.config.permittedInsecurePackages = [
     "samba-3.6.25"
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
  ];
  boot.cleanTmpDir = true;
}
