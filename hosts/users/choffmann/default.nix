{
  pkgs,
  inputs,
  outputs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  githubPubKeys = pkgs.fetchurl {
    url = "https://github.com/choffmann.keys";
    sha256 = "a20843af96a6254e11b8d506a38ee7d8a651280b2397b7abbf5b7f85760da3fe";
  };
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
in {
  users.users.choffmann = {
    initialPassword = "geheim";
    description = "Cedrik Hoffmann";
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      pkgs.lib.splitString "\n" (builtins.readFile githubPubKeys)
      ++ lib.lists.forEach pubKeys (key: builtins.readFile key);
    extraGroups =
      ["wheel"]
      ++ ifTheyExist [
        "docker"
        "git"
        "networkmanager"
      ];
  };

  users.users.root = {
    initialPassword = "geheim";
    openssh.authorizedKeys.keys =
      pkgs.lib.splitString "\n" (builtins.readFile githubPubKeys)
      ++ lib.lists.forEach pubKeys (key: builtins.readFile key);
  };

  programs.zsh.enable = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      choffmann = import ../../../home/choffmann;
    };
    backupFileExtension = "backup";
  };

  security.pam.services.sudo = {
    rules.auth.rssh = {
      order = config.rules.auth.ssh_agent_auth.order - 1;
      control = "sufficient";
      modulePath = "${pkgs.pam_rssh}/lib/libpam+rssh.so";
      settings.authorized_keys_command = pkgs.writeShellScript "get-authorized-keys" ''
        cat "/etc/ssh/authorized_keys.d/$1"
      '';
    };
  };
}
