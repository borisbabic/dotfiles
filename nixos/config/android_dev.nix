
{ pkgs, ... }:

# let
#   androidComposition = pkgs.androidenv.composeAndroidPackages {
#     buildToolsVersions = [ "34.0.0" ];
#     platformVersions = [ "34" ];
#     abiVersions = [ "x86_64" ];
#     includeEmulator = true;
#     includeSources = true;
#     includeSystemImages = true;
#   };
# in
{
  environment.systemPackages = with pkgs; [
    jdk
    android-tools
    # android-studio-tools
    # android-studio-full
    # androidComposition.androidsdk
    gradle
    scrcpy
  ];
  services.envfs.enable = true;
  programs.nix-ld.enable = true;

  # environment.sessionVariables = {
  #   ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
  # };
  nixpkgs.config.android_sdk.accept_license = true;
  users.users.boris.extraGroups = ["kvm" "adb" "adbusers"];
}
