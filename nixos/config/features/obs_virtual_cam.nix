{ config, ... }:
{
  boot = {
    kernelModules = [ 
      "v4l2loopback" 
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    extraModulePackages = with config.boot.kernelPackages; [
      # for virtual cam in OBS
      v4l2loopback
    ];
  };
}
