{ pkgs, ... }:
{
  imports = [
    ./obs_virtual_cam.nix
  ];
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-vaapi
    ];
  };
}
