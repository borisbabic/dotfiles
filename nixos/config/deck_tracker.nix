{pkgs, ...}:

let userlocal = ''
  for i in $out/sdk/*; do
    i=$(basename $i)
    length=$(printf "%s" "$i" | wc -c)
    substring=$(printf "%s" "$i" | cut -c 1-$(expr $length - 2))
    i="$substring""00"
    mkdir -p $out/metadata/workloads/''${i/-*}
    touch $out/metadata/workloads/''${i/-*}/userlocal
 done
'';
# append userlocal sctipt to postInstall phase
postInstallUserlocal = (finalAttrs: previousAttrs: {
    postInstall = (previousAttrs.postInstall or '''') + userlocal;
});
# append userlocal sctipt to postBuild phase
postBuildUserlocal = (finalAttrs: previousAttrs: {
    postBuild = (previousAttrs.postBuild or '''') + userlocal;
});

dotnet-combined = (with pkgs.dotnetCorePackages;
  combinePackages [
    (sdk_10_0.overrideAttrs postInstallUserlocal)
    (sdk_8_0.overrideAttrs postInstallUserlocal)
  ]
).overrideAttrs postBuildUserlocal;

in

{
  environment.systemPackages = with pkgs; [
    jdk
    android-tools
    android-studio-full
    gradle
    dotnet-combined
    # dotnet-dotnet-sdk_10
  ];
  services.envfs.enable = true;

  # programs.adb.enable = true;
  nixpkgs.config.android_sdk.accept_license = true;
  users.users.boris.extraGroups = ["kvm" "adb"];
  # services.udev.packages = [
  #   pkgs.android-udev-rules
  # ];
}
