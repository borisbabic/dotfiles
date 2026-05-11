
{ config, pkgs, ... }:
{
  home.stateVersion = "25.11"; # Did you read the comment?
  services.arrpc = {
    enable = true;
  };
  # systray proxy
  # enables wine systrays to be in regular wayland systray
  services.xembed-sni-proxy = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    # plugins = [
    #   pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    # ];
  };
  services.kdeconnect.enable = true;

  programs.nix-index.enable = true;

  programs.calibre = {
    enable = true;
  };
}
