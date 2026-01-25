{pkgs, ...}:
{

  environment.systemPackages = with pkgs; [
    stremio
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];
}
