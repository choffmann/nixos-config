{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.autoLogin;
in {
  options.autoLogin = {
    enable = lib.mkEnableOption "Enable automatic login";

    username = lib.mkOption {
      type = lib.types.str;
      default = "guest";
      description = "User to automatically login";
    };
  };

  config = {
    boot.kernelParams = ["console=tty1"];
    services.greetd = {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --asterisks --time --time-format '[%H:%M] [%a %d.%m]' --greeting 'λ ❯ login' --cmd Hyprland";
        };

        initial_session = lib.mkIf cfg.enable {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "${cfg.username}";
        };
      };
    };
  };
}
