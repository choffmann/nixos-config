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
    kernelModules = ["kvm-${platform}" "vfio_pci" "vfio_iommu_type1" "vfio"];
    kernelParams = [
      "${platform}_iommu=on"
      "${platform}_iommu=pt"
      "kvm.ignore_msrs=1"
      "default_hugepagesz=2M"
      "hugepagesz=2M"
      "hugepages=8192" # 16GB for VM
    ];
    extraModulePackages = [config.boot.kernelPackages.kvmfr];
    extraModprobeConfig = ''
      options vfio-pci ids=${builtins.concatStringsSep "," vfioIds}
      options kvmfr static_size_mb=128
    '';
  };

  # Load kvmfr via systemd (after udev is ready)
  systemd.services.kvmfr-load = {
    description = "Load kvmfr module";
    wantedBy = ["multi-user.target"];
    after = ["systemd-udev-settle.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.kmod}/bin/modprobe kvmfr";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", KERNEL=="kvmfr*", GROUP="kvm", MODE="0660"
  '';

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
    virtio-win
    win-spice
    looking-glass-client
    adwaita-icon-theme
  ];

  programs.dconf.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";

      qemu = {
        package = pkgs.qemu_kvm;
        vhostUserPackages = [pkgs.virtiofsd];
        swtpm.enable = true;
        verbatimConfig = ''
          cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/kvm",
              "/dev/kvmfr0"
          ]
          # Suppress USB device property warnings
          log_level = 3
          log_filters = "3:remote 4:event 3:util.json 3:util.object 3:util.dbus 3:util.udev 3:node_device 3:rpc 3:access"
        '';
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  systemd.services.libvirtd.wantedBy = pkgs.lib.mkForce [];

  users.users.${user}.extraGroups = ["qemu-libvirtd" "libvirtd" "disk"];

  # Hugepages for VM memory
  systemd.mounts = [
    {
      where = "/dev/hugepages";
      what = "hugetlbfs";
      type = "hugetlbfs";
      options = "mode=0775,gid=libvirtd";
      wantedBy = ["multi-user.target"];
    }
  ];
}
