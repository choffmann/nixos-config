{
  pkgs,
  inputs,
  outputs,
  config,
  lib,
  ...
}:
let
  inherit (config) hostSpec;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  githubPubKeys = pkgs.fetchurl {
    url = "https://github.com/choffmann.keys";
    sha256 = "sha256-H94jG54YGywMqYp+ICv5SDeKZITHJLLGt1+VPPZgcFo=";
  };
  pubKeys = lib.filesystem.listFilesRecursive ./keys;

  tpp_keys = ''
    command="export NAME='fpetersen' && zsh -il" sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKP9gP8CiPE4akTr0pS3HIdZ2WJhAffoIp0D1tt+UbIgAAAABHNzaDo=
    command="export NAME='fpetersen' && zsh -il" sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHn89LV7UCzQCcgtjzfjmKYAhoHLlnHzJvTTzcoSJh0rAAAABHNzaDo=
  '';
in
{
  users.users.choffmann = {
    initialPassword = "geheim";
    description = "Cedrik Hoffmann";
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      pkgs.lib.splitString "\n" (builtins.readFile githubPubKeys)
      ++ lib.lists.forEach pubKeys (key: builtins.readFile key)
      ++ pkgs.lib.splitString "\n" tpp_keys;

    extraGroups = [
      "wheel"
    ]
    ++ ifTheyExist [
      "docker"
      "git"
      "networkmanager"
      "gamemode"
      "kvm"
    ];
  };

  # Create ssh sockets directory for controlpaths
  systemd.tmpfiles.rules =
    let
      user = config.users.users.choffmann.name;
      group = config.users.users.choffmann.group;
    in
    [ "d /home/choffmann/.ssh/sockets 0750 ${user} ${group} -" ];

  users.users.root = {
    initialPassword = "geheim";
    openssh.authorizedKeys.keys =
      pkgs.lib.splitString "\n" (builtins.readFile githubPubKeys)
      ++ lib.lists.forEach pubKeys (key: builtins.readFile key);
  };

  programs.zsh.enable = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
      inherit (config) hostSpec;
    };
    users.${hostSpec.username} = import (
      lib.custom.relativeToRoot "home/${hostSpec.username}/${hostSpec.hostName}.nix"
    );
  };

  home-manager.users.root = {
    home.stateVersion = "24.11";
    programs.zsh.enable = true;
  };
}
