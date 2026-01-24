{ config, pkgs, ... }:
{
  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;
  # slight performance
  services.system76-scheduler.enable = true;
  # enables clipboard, but opens the clipboard to everything
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
}
