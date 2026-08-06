{pkgs, ...} :

{
  environment.systemPackages = with pkgs; [
    jdk
    android-tools
    android-studio-full
    gradle
    antigravity
  ];
  services.envfs.enable = true;

  programs.adb.enable = true;
  nixpkgs.config.android_sdk.accept_license = true;
  users.users.boris.extraGroups = ["kvm" "adb" "adbusers"];
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  home.antigravity = {
    enable = true;
    mutableExtensionsDir = true;
  };
}
