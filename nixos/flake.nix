{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stremio-pr.url = "github:NixOS/nixpkgs/pull/460557/head";
  };
  outputs = { self, nixpkgs, stremio-pr, ... }@inputs:
    {
    nixosConfigurations.nixos-legion5 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.legion5.nix
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
