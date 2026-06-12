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

    settings = {
      "*" = {
        ControlMaster = "auto";
        ControlPath = "~/.ssh/sockets/S.%r@%h:%p";
        ControlPersist = "10m";
        IdentityFile = [
          "~/.ssh/id_choffmann"
          "~/.ssh/id_yubikey"
        ];
        AddKeysToAgent = "yes";
        SetEnv = {TERM = "xterm-256color";};
      };
      "gitlab.com github.com git.progeek.de gitlab.progeek.de gitlab.hs-flensburg.de gitlab.crypto.tii.ae" = {
        User = "git";
        IdentityFile = [
          "~/.ssh/id_yubikey" # auto symlink to yubikey
          "~/.ssh/id_choffmann"
        ];
      };
      "gitlab.hs-flensburg.de" = {
        User = "git";
        Port = 22006;
        IdentityFile = [
          "~/.ssh/id_yubikey" # auto symlink to yubikey
          "~/.ssh/id_choffmann"
        ];
      };
      "gitlab-runner-1".IdentityFile = "~/.ssh/id_choffmann";
      "*.homebin.dev" = {
        User = "root";
        IdentityFile = "~/.ssh/id_choffmann";
      };
      "mail.green-ecolution.de" = {
        User = "root";
        IdentityFile = "~/.ssh/id_mail_green_ecolution";
      };
      "home-pc" = {
        User = "choffmann";
        IdentityFile = "~/.ssh/id_choffmann";
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
