{...}:
{
  imports = [
    ./dms.nix
    ./greetd.nix

  ];
  # environment.sessionVariables = {
  #   WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
  # };
  programs.mango = {
    enable = true;
  };
}

