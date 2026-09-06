{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.autoLogin;
  # sessionPackages land here; tuigreet lists every entry as a choice.
  sessionDirs = "/run/current-system/sw/share/wayland-sessions";
in
{
  options.autoLogin = {
    enable = lib.mkEnableOption "Enable automatic login";

    username = lib.mkOption {
      type = lib.types.str;
      default = "guest";
      description = "User to automatically login";
    };

    session = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.hyprland}/bin/start-hyprland";
      description = "Full command started for the auto-login session";
    };
  };

  config = {
    boot.kernelParams = [ "console=tty1" ];
    services.greetd = {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --asterisks --time --time-format '[%H:%M] [%a %d.%m]' --greeting 'λ ❯ login' --sessions ${sessionDirs} --remember --cmd start-hyprland";
        };

        initial_session = lib.mkIf cfg.enable {
          command = cfg.session;
          user = cfg.username;
        };
      };
    };
  };
}
