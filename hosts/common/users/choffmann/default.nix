{
  pkgs,
  inputs,
  config,
  lib,
  configVars,
  configLib,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  sopsHashedPasswordFile =
    lib.optionalString (lib.hasAttr "sops-nix" inputs)
      config.sops.secrets."${configVars.username}/password".path;
  pubKeys = pkgs.fetchurl {
    url = "https://github.com/choffmann.keys";
    sha256 = "a20843af96a6254e11b8d506a38ee7d8a651280b2397b7abbf5b7f85760da3fe";
  };

  fullUserConfig = lib.optionalAttrs (!configVars.isMinimal) {
    users.users.${configVars.username} = {
      hashedPasswordFile = sopsHashedPasswordFile;
      packages = [ pkgs.home-manager ];
    };

    # Import this user's personal/home configurations
    home-manager.users.${configVars.username} = import (
      configLib.relativeToRoot "home/${configVars.username}/${config.networking.hostName}.nix"
    );
  };
in
{
  config =
    lib.recursiveUpdate fullUserConfig
      {
        users.mutableUsers = false; # Only allow declarative credentials; Required for sops
        users.users.${configVars.username} = {
          home = "/home/${configVars.username}";
          isNormalUser = true;
          initialPassword = "geheim";
          password = "geheim"; # Overridden if sops is working

          extraGroups =
            [ "wheel" ]
            ++ ifTheyExist [
              "docker"
              "git"
              "networkmanager"
            ];

          # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
          openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile pubKeys);
          shell = pkgs.zsh; # default shell
        };

        # Proper root use required for borg and some other specific operations
        users.users.root = {
          hashedPasswordFile = config.users.users.${configVars.username}.hashedPasswordFile;
          initialPassword = "geheim";
          password = lib.mkForce config.users.users.${configVars.username}.password;
          # root's ssh keys are mainly used for remote deployment.
          openssh.authorizedKeys.keys = config.users.users.${configVars.username}.openssh.authorizedKeys.keys;
        };

        # No matter what environment we are in we want these tools for root, and the user(s)
        programs.zsh.enable = true;
        programs.git.enable = true;
        environment.systemPackages = [
          # More packages
        ];
      };
}
