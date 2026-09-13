{pkgs, ...}:
{
  imports = [
    ./dms.nix
    ./greetd.nix

  ];
  programs.niri = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [ fuzzel alacritty];
}

