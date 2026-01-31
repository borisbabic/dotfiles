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
  };
  outputs = { self, nix-flatpak, nixpkgs, stremio-pr, ... }@inputs:
    {
    nixosConfigurations.nixos-legion5 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.legion5.nix
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
