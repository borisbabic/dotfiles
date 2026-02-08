{pkgs,...}:
{
  #
  # Set up virtualisation
  virtualisation.libvirtd = {
      enable = true;

      # Enable TPM emulation (for Windows 11)
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };

    # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;

  # Allow VM management
  users.groups.libvirtd.members = [ "boris" ];
  users.groups.kvm.members = [ "boris" ];

  # Enable VM networking and file sharing
  environment.systemPackages = with pkgs; [
      virt-manager
      # ... your other packages ...
      gnome-boxes # VM management
      dnsmasq # VM networking
      phodav # (optional) Share files with guest VMs
  ];
}
