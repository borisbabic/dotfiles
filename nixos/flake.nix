{
  inputs = {
    dms-plugin-calendar = {
      url = "github:alcxyz/DankCalendar";
      flake = true;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # hyprland.url = "github:hyprwm/Hyprland";
    stremio-pr.url = "github:NixOS/nixpkgs/pull/460557/head";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # dms = {
    #   #url = "path:/home/boris/projects/DankMaterialShell";
    #   # url = "github:borisbabic/DankMaterialShell";
    #   # url = "github:AvengeMedia/DankMaterialShell/pull/2419/head";
    #   url = "github:AvengeMedia/DankMaterialShell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
  };
  outputs = { self, sops-nix, nix-flatpak, nixpkgs, stremio-pr, clutch-notifier, home-manager, ... }@inputs:
    {
    nixosConfigurations.nixos-legion5 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        userHome = "/home/boris";
      };
      modules = [
        ./configuration.legion5.nix
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
            (final: prev: {
                chatterino7 = let noOverride =
                  prev.lib.versionAtLeast prev.chatterino7.version "7.5.6";
                in
                prev.lib.warnIf noOverride ''
                    chatterino7 >= 7.5.6 is now in nixpkgs, the override can be removed
                ''
                (if noOverride then
                  prev.chatterino7
                else
                  prev.chatterino7.overrideAttrs (old: {
                    version = "nightly-master";
                    src = prev.fetchFromGitHub {
                      owner = "seventv";
                      repo = "chatterino7";
                      rev = "b4628fa7eb5619b0f9a1bc59593450b5915d46d7";
                      fetchSubmodules = true;
                      hash = "sha256-M3gMhjqgR7VwxtcixpvbqqTLsbNgNZqJ81rb4aNZkTs=";
                    };
                  })
                );
              })
            # (final: prev: {
            #     antigravity-ide = let noOverride =
            #       prev.lib.versionAtLeast prev.antigravity-ide.version "2.5.5";
            #     in
            #     prev.lib.warnIf noOverride ''
            #         antigravity-ide>= 2.5.5 is now in nixpkgs, the override can be removed
            #     ''
            #     (if noOverride then
            #       prev.antigravity-ide
            #     else
            #       prev.antigravity-ide.overrideAttrs (old: {
            #         version = "2.5.5";
            #       })
            #     );
            #   })
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
