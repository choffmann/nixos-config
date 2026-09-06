{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    sops
  ];

  sops = {
    defaultSopsFile = lib.custom.relativeToRoot "secrets/secrets.yaml";
    defaultSopsFormat = "yaml";

    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";

    secrets = {
      "ssh_keys/choffmann" = {
        path = "${homeDir}/.ssh/id_choffmann";
      };
      "ssh_keys/yubi" = {
        path = "${homeDir}/.ssh/id_yubi";
      };
      "ssh_keys/mail.green-ecolution.de" = {
        path = "${homeDir}/.ssh/id_mail_green_ecolution";
      };
      # Signs commits Claude Code makes on its own. Passphrase-less on purpose:
      # the yubikey is out while it works, so nothing can answer a pinentry.
      "ssh_keys/claude-signing" = {
        path = "${homeDir}/.ssh/id_claude_signing";
      };
    };
  };
}
