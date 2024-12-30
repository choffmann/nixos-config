{lib, ...}: let
  pathToKeys = ../../../hosts/users/choffmann/keys;
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
    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "10m";

    extraConfig = ''
      AddKeysToAgent yes
    '';

    matchBlocks = {
      "git" = {
        host = "gitlab.com github.com";
        user = "git";
        identityFile = [
          "~/.ssh/id_yubikey" # auto symlink to yubikey
        ];
      };
    };
  };

  home.file =
    {
      ".ssh/sockets/.keep".text = "# Managed by Home Manager";
    }
    // yubikeyPublicKeyEntries;
}
