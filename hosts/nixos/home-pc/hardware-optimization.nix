{
  config,
  pkgs,
  lib,
  ...
}:
{
  # AMD Ryzen 7000 + RX 7600 Hardware Optimizations

  boot.kernelParams = [
    "amd_pstate=active"
    "transparent_hugepage=madvise"
    "iommu=pt"
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Force RADV for better gaming performance
  environment.variables.AMD_VULKAN_ICD = "RADV";

  # SSD TRIM
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  fileSystems = {
    "/".options = [
      "noatime"
      "nodiratime"
    ];
    "/boot".options = [
      "noatime"
      "nodiratime"
    ];
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "fs.inotify.max_user_watches" = 524288;
    "fs.file-max" = 2097152;
  };

  boot.extraModprobeConfig = ''
    # Enable all PowerPlay features
    options amdgpu ppfeaturemask=0xffffffff
    # Nested virtualization
    options kvm-amd nested=1 npt=1
  '';
}
