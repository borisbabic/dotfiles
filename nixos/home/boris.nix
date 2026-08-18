
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
  services.kdeconnect.enable = true;

  programs.nix-index.enable = true;

  programs.calibre = {
    enable = true;
  };
  programs.vesktop = {
    enable = true;
  };
  home.file."dotfiles/.luarc.json" = {
    text = builtins.toJSON {
      workspace = {
        library = [
          "${pkgs.hyprland}/share/hypr/stubs"
        ];
      };
      diagnostics = {
        globals = ["hl"];
      };
    };
  };
  home.file.".local/share/chatterino/Plugins/chatterino-auto-translate" = {
    source = pkgs.fetchFromGitHub {
      owner = "MrMalvic";
      repo = "chatterino-auto-translate";
      rev = "d73ee8b";  # e.g., "v1.0.0" or full commit sha
      hash = "sha256-vKt6SC2s5UbY5oJjpxdFez54iiVVn3EU6wI8zf1CNg0="; # Replace after first build attempt
    };
    recursive = true;
  };

  home.file.".config/streamlink/config.twitch" = {
    text = ''
      twitch-low-latency
      twitch-supported-codecs=h265,h264,av1
    '';
  };
  home.file.".config/streamlink/config" = {
    text = ''
      player=vlc
      player-args=--no-one-instance
      player-no-close
  '';
   };

  programs.antigravity-cli = {
    enable = true;
  };
  programs.antigravity = {
    package = pkgs.antigravity-ide;
    enable = true;
    mutableExtensionsDir = true;
  };
}
