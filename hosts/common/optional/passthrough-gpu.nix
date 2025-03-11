{
  pkgs,
  config,
  ...
}: let
  user = "choffmann";
  platform = "amd";
  vfioIds = ["10de:1b81" "10de:10f0"];
in {
  boot = {
    kernelModules = ["kvm-${platform}" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio"];
    kernelParams = ["${platform}_iommu=on" "${platform}_iommu=pt" "kvm.ignore_msrs=1"];
    extraModprobeConfig = "options vfio-pci ids=${builtins.concatStringsSep "," vfioIds}";
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 ${user} qemu-libvirtd -"
  ];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    virtiofsd
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    looking-glass-client
    gnome.adwaita-icon-theme
  ];

  programs.dconf.enable = true;
  security.pam.loginLimits = [
    {
      domain = "@kvm";
      type = "hard";
      item = "memlock";
      value = "28388608";
    }
    {
      domain = "@kvm";
      type = "soft";
      item = "memlock";
      value = "28388608";
    }
  ];

  systemd.services.libvirtd.serviceConfig = {
    LimitMEMLOCK = "infinity";
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      # extraConfig = ''
      #   user="${user}"
      # '';
      #
      onBoot = "ignore";
      onShutdown = "shutdown";

      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
        # verbatimConfig = ''
        #    namespaces = []
        #   user = "+${builtins.toString config.users.users.${user}.uid}"
        # '';
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  users.users.${user}.extraGroups = ["qemu-libvirtd" "libvirtd" "disk"];
}
