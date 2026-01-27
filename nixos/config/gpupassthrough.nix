{config, pkgs, ...}:
{
  specialisation.gpu-passthrough.configuration = {
    systemd.tmpfiles.rules = [
          "f /dev/shm/looking-glass 0660 boris libvirtd -"
        ];
    boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
    boot.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    boot.initrd.kernelModules = ["vfio_pci" "vfio" "vfio_iommu_type1"];
    boot.extraModprobeConfig = ''
      options vfio-pci ids=10de:2d18,10de:22eb
    '';
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        # ovmf.enable = true;
        # ovmf.packages = [ pkgs.OVMFFull ];
        swtpm.enable = true;
      };
    };
    users.users.boris = {
      extraGroups = [ "libvirtd" "kvm" ];
    };
    programs.virt-manager.enable = true;
    environment.systemPackages = [ pkgs.looking-glass-client ];
  };
}
