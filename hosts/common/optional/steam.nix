{
  pkgs,
  config,
  ...
}: {
  # Required for Steam Input virtual gamepad emulation (Steam Link, Remote Play).
  # Installs udev rules for /dev/uinput so Steam can expose remote controller
  # input (e.g. from Apple TV Steam Link) as a virtual XInput/DualSense device.
  hardware.steam-hardware.enable = true;

  # Ensure uinput is available at boot for Steam Input
  boot.kernelModules = ["uinput"];

  # Grant the primary user access to /dev/uinput via the input group
  users.users.${config.hostSpec.username}.extraGroups = ["input"];

  programs = {
    steam = {
      enable = true;
      # Open ports 27031-27036 for Steam Remote Play / Steam Link discovery
      remotePlay.openFirewall = true;
      # Open ports for transferring installed games between LAN PCs
      localNetworkGameTransfers.openFirewall = true;
      protontricks = {
        enable = true;
        package = pkgs.protontricks;
      };
      package = pkgs.steam.override {
        extraPkgs = pkgs: (builtins.attrValues {
          inherit
            (pkgs.stdenv.cc.cc)
            lib
            ;

          inherit
            (pkgs)
            libxcursor
            libxi
            libxinerama
            libxscrnsaver
            libpng
            libpulseaudio
            libvorbis
            libkrb5
            keyutils
            gperftools
            ;
        });
      };
      extraCompatPackages = [pkgs.unstable.proton-ge-bin];
    };
    #gamescope launch args set dynamically in home/<user>/common/optional/gaming
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    # to run steam games in game mode, add the following to the game's properties from within steam
    # gamemoderun %command%
    gamemode = {
      enable = true;
      settings = {
        #see gamemode man page for settings info
        general = {
          softrealtime = "on";
          inhibit_screensaver = 1;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1; # The DRM device number on the system (usually 0), ie. the number in /sys/class/drm/card0/
          amd_performance_level = "high";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
