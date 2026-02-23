{
  pkgs,
  lib,
  ...
}: let
  pathToKeys = lib.custom.relativeToRoot "hosts/common/users/choffmann/keys";
  yubikeys =
    lib.lists.forEach (builtins.attrNames (builtins.readDir pathToKeys))
    # Remove the .pub suffix
    (key: lib.substring 0 (lib.stringLength key - lib.stringLength ".pub") key);
  yubikeyPublicKeyEntries = lib.attrsets.mergeAttrsList (
    lib.lists.map
    # list of dicts
    (key: {".ssh/${key}.pub".source = "${pathToKeys}/${key}.pub";})
    yubikeys
  );
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/sockets/S.%r@%h:%p";
        controlPersist = "10m";
        identityFile = [
          "~/.ssh/id_choffmann"
          "~/.ssh/id_yubikey"
        ];
        extraOptions = {
          AddKeysToAgent = "yes";
          SetEnv = "TERM=xterm-256color";
        };
      };
      "git" = {
        host = "gitlab.com github.com git.progeek.de gitlab.progeek.de gitlab.hs-flensburg.de gitlab.crypto.tii.ae";
        user = "git";
        identityFile = [
          "~/.ssh/id_yubikey" # auto symlink to yubikey
          "~/.ssh/id_choffmann"
        ];
      };
      "git@hs-flensburg" = {
        host = "gitlab.hs-flensburg.de";
        user = "git";
        port = 22006;
        identityFile = [
          "~/.ssh/id_yubikey" # auto symlink to yubikey
          "~/.ssh/id_choffmann"
        ];
      };
      "progeek" = {
        host = "gitlab-runner-1";
        identityFile = [
          "~/.ssh/id_choffmann"
        ];
      };
      "homebin.dev" = {
        host = "*.homebin.dev";
        user = "root";
        identityFile = [
          "~/.ssh/id_choffmann"
        ];
      };
      "mail.green-ecolution.de" = {
        host = "mail.green-ecolution.de";
        user = "root";
        identityFile = [
          "~/.ssh/id_mail_green_ecolution"
        ];
      };
      "home-pc" = {
        user = "choffmann";
        identityFile = [
          "~/.ssh/id_choffmann"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    lemonade
  ];

  home.file =
    {
      ".ssh/sockets/.keep".text = "# Managed by Home Manager";
      ".config/lemonade.toml".text = ''
        allow = '0.0.0.0/0'
      '';
    }
    // yubikeyPublicKeyEntries;
}
