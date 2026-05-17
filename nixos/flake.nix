{
  inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    stremio-pr.url = "github:NixOS/nixpkgs/pull/460557/head";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      #url = "path:/home/boris/projects/DankMaterialShell";
      # url = "github:borisbabic/DankMaterialShell";
      # url = "github:AvengeMedia/DankMaterialShell/pull/2419/head";
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    clutch-notifier = {
      url = "github:borisbabic/clutch-notifier";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, sops-nix, nix-flatpak, nixpkgs, stremio-pr, clutch-notifier, home-manager,  mangowm, nix-cachyos-kernel, dms, ... }@inputs:
    {
    nixosConfigurations.nixos-legion5 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        userHome = "/home/boris";
      };
      modules = [
        ./configuration.legion5.nix
        mangowm.nixosModules.mango
        sops-nix.nixosModules.sops
        clutch-notifier.nixosModules.default
        home-manager.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.boris = ./home/boris.nix;
          };
          nixpkgs.overlays = [
            nix-cachyos-kernel.overlays.default
            (final: prev: {
              stremio-service = (import stremio-pr {
                system = prev.stdenv.hostPlatform.system;
                config.allowUnfree = true;
              }).stremio-service;
            })
            # workaround for issue on unstable
            (_: prev: {
              openldap = prev.openldap.overrideAttrs {
                doCheck = !prev.stdenv.hostPlatform.isi686;
              };
            })
          ];
        }
      ];
    };
  };
}
