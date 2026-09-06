# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    synology-drive-client = prev.synology-drive-client.overrideAttrs (_oldAttrs: rec {
      version = "4.0.1-17885";
      src = prev.fetchurl {
        url = "https://global.synologydownload.com/download/Utility/SynologyDriveClient/${version}/Ubuntu/Installer/synology-drive-client-17885.x86_64.deb";
        sha256 = "1j18baahvbfcsycwnrycgzgzb654rhk3a0179zb4jiilra3ymh8c";
      };
      autoPatchelfIgnoreMissingDeps = [
        "libnautilus-extension.so.4"
        "libQt5Pdf.so.5"
      ];
    });
  };

  # nixpkgs' dms-shell module hardcodes pkgs.dgop/matugen/cava/quickshell, so
  # the newer builds can only be injected here, not through module options.
  # dsearch and dcal are not listed: their home-manager modules default to the
  # package from their own flake.
  dank-packages =
    final: _prev:
    let
      inherit (final.stdenv.hostPlatform) system;
    in
    {
      inherit (inputs.dms.packages.${system}) dms-shell;
      inherit (inputs.dgop.packages.${system}) dgop;
      inherit (final.unstable) quickshell matugen cava;
    };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
