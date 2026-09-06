{
  config,
  pkgs,
  ...
}:
let
  inherit (config.hostSpec) home;

  wallpaper = "${config.desktop.wallpaper}";

  # cp keeps the basename, so the greeter only recognises this file if the
  # store path ends in "session.json".
  greeterSession = "${
    pkgs.writeTextDir "session.json" (
      builtins.toJSON {
        wallpaperPath = wallpaper;
        wallpaperPathLight = wallpaper;
        wallpaperPathDark = wallpaper;
        wallpaperFillMode = "PreserveAspectCrop";
        isLightMode = false;
      }
    )
  }/session.json";
in
{
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";

    # configHome is deliberately unset: the module appends its home-derived
    # files after configFiles, so the live session.json would win over the
    # wallpaper pinned below.
    configFiles = [
      "${home}/.config/DankMaterialShell/settings.json"
      "${home}/.cache/DankMaterialShell/dms-colors.json"
      greeterSession
    ];
  };

  # greetd carries X-RestartIfChanged=false, so a switch never re-runs its
  # preStart: changes here only reach /var/lib/dms-greeter after a reboot.

  # Keeps a usable TTY to fall back to if the greeter fails to come up.
  boot.kernelParams = [ "console=tty1" ];
}
