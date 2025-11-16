{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    synology-drive-client
  ];

  home.activation.synologyDriveSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p /storage/hdd/SynologyDrive
    $DRY_RUN_CMD chmod 755 /storage/hdd/SynologyDrive

    # Symlink from home to HDD
    if [ ! -L ${config.home.homeDirectory}/SynologyDrive ]; then
      $DRY_RUN_CMD rm -rf ${config.home.homeDirectory}/SynologyDrive
      $DRY_RUN_CMD ln -sf /storage/hdd/SynologyDrive ${config.home.homeDirectory}/SynologyDrive
    fi
  '';
}
