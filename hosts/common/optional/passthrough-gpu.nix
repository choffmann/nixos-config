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
    kernelModules = ["kvm-${platform}" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" "kvmfr"];
    kernelParams = ["${platform}_iommu=on" "${platform}_iommu=pt" "kvm.ignore_msrs=1"];
    extraModulePackages = [config.boot.kernelPackages.kvmfr];
    extraModprobeConfig = ''
      options vfio-pci ids=${builtins.concatStringsSep "," vfioIds}
      options kvmfr static_size_mb=128
    '';
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="${user}", GROUP="kvm", MODE="0660"
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
    win-virtio
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
        ovmf = {
          enable = true;
          packages = let
            ovmfSecure = (pkgs.OVMFFull.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd;
          in [
            ovmfSecure
          ];
        };
        verbatimConfig = ''
          cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/kvm",
              "/dev/kvmfr0"
          ]
        '';
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  users.users.${user}.extraGroups = ["qemu-libvirtd" "libvirtd" "disk"];
}
