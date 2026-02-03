{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    stremio-pr.url = "github:NixOS/nixpkgs/pull/460557/head";
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, sops-nix, nix-flatpak, nixpkgs, stremio-pr, ... }@inputs:
    {
    nixosConfigurations.nixos-legion5 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        userHome = "/home/boris";
      };
      modules = [
        ./configuration.legion5.nix
        sops-nix.nixosModules.sops
        nix-flatpak.nixosModules.nix-flatpak
        {
              nixpkgs.overlays = [
                (final: prev: {
                  stremio-service = (import stremio-pr {
                    system = prev.stdenv.hostPlatform.system;
                    config.allowUnfree = true;
                  }).stremio-service;
                })
              ];
            }
      ];
    };
  };
}
