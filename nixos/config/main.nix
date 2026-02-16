# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./cosmic.nix
      ./gaming.nix
      ./nonguipackages.nix
      ./15irx10.nix
      ./stremio.nix
      ./hyprland.nix
      ./hsguru.nix
      ./deck_tracker.nix
      ./virt.nix
      # ./gpupassthrough.nix
    ];
  environment.sessionVariables = {
    # Tell XWayland apps (like Steam) not to scale themselves
    "GDK_SCALE" = "1";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zagreb";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hr_HR.UTF-8";
    LC_IDENTIFICATION = "hr_HR.UTF-8";
    LC_MEASUREMENT = "hr_HR.UTF-8";
    LC_MONETARY = "hr_HR.UTF-8";
    LC_NAME = "hr_HR.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "hr_HR.UTF-8";
    LC_TELEPHONE = "hr_HR.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # {
  #   # Enable the COSMIC login manager
  #   services.displayManager.cosmic-greeter.enable = true;

  #   # Enable the COSMIC desktop environment
  #   services.desktopManager.cosmic.enable = true;
  # }

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,hr";
    variant = "";
  };

  services.keyd = {
    enable = true;
    keyboards = {
      # Replace "0000:0000" with the ID you found in step 1
      default = {

        ids = [ "*" ];
        settings = {

          main = {
            capslock = "esc";
          };
        };
      };
      cheapo = {
        ids = ["c0f4:0201:5ab70009" ];
        settings = {
          main = {
            capslock = "esc";
            esc = "grave";
            compose = "sysrq"; # In keyd/Linux, 'sysrq' is the code for PrintScreen
            insert = "play";
          };
        };
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  #
  programs.kdeconnect.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.boris = {
    isNormalUser = true;
    description = "Boris";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # kdePackages.kate
    #  thunderbird
    ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  environment.shellAliases = {
    rebuild="sudo nixos-rebuild --flake=/home/boris/dotfiles/nixos/\\#${config.networking.hostName} ";
  };


  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    jetbrains.rider
    super-productivity
    bitwarden-desktop
    # language server for nix for zed
    nixd
    zed-editor
    chatterino7
    # discord rich presence
    arrpc
    webcord-vencord
    # discord
    kitty
    # albert
    spotify
    # brave
    # task manager / system monitor
    mission-center
    # stremio
    whatsapp-electron
    # provides nix-locate which can find libraries
    nix-index
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pavucontrol
    playerctl
    chromium
    motrix
  ];

  programs.obs-studio.enableVirtualCamera = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
  };
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  fonts.packages = with pkgs; [
    # Standard Nerd Fonts (includes icons for almost everything)
    nerd-fonts.symbols-only
    nerd-fonts.fira-code

    # Or specifically Font Awesome if that's what your config uses
    font-awesome
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.clutch-notifier = {
    enable = true;
    minutesRemaining = 8;
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
