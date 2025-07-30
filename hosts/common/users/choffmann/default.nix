{
  pkgs,
  inputs,
  outputs,
  config,
  lib,
  ...
}: let
  hostSpec = config.hostSpec;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  githubPubKeys = pkgs.fetchurl {
    url = "https://github.com/choffmann.keys";
    sha256 = "sha256-H94jG54YGywMqYp+ICv5SDeKZITHJLLGt1+VPPZgcFo=";
  };
  pubKeys = lib.filesystem.listFilesRecursive ./keys;

  tpp_keys = ''
    command="export NAME='fpetersen' && zsh -il" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEOsvUsN/dvlzg9T2ZLLkpyMKlJWGwWjXadOm7NNDgrhtOR9SKUxCUJuMbRiBOSpwneYSdeZHBFR/SG7zzpek7ZO2n4OojR1hztcqRus2MYo1bDqQekLpapcsTCbMLTZhrzjylsAGAaJ79Y+ArXKlocCvElfGwTCP8OFNgzOcJnbN6XC9kI8QYIrKzfuQUTbyd5xiV/YZ7Dm2hlBkVTYlGu+sijml6Qgnpy/zzWC2Cs9sjE1wSGFLQp2bN/QQSe3Gl8Y2mZc4/JBzPws735Pbydi4QXOdiGGFaSr/Ldm1VTet+p6ey7BtTl3lwblCy1gCHO7pxLw1nocdK7F7sH8qbUQQ/QsKzY7BnzkZn+/VIP7eOh1tlzRoJuOFucJCMkeid6/p+YoO5ga31oVttk89T7w9DgpMajzjb1B/o78FM6SNEvo6BjtPCFQU8v8Y1TTHIyhV7bJoZwqEn+PMbS/jtmf3Tghzaw5ClsimnO7XLxDz4h5o5h+gjFJcQT4i/uy0=
    command="export NAME='fpetersen' && zsh -il" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBOlLAlgnKyBt7RTgPxt2OW8atZOHt2l+jc+BzUfCi1i
  '';
in {
  users.users.choffmann = {
    initialPassword = "geheim";
    description = "Cedrik Hoffmann";
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      pkgs.lib.splitString "\n" (builtins.readFile githubPubKeys)
      ++ lib.lists.forEach pubKeys (key: builtins.readFile key)
      ++ pkgs.lib.splitString "\n" tpp_keys;

    extraGroups =
      ["wheel"]
      ++ ifTheyExist [
        "docker"
        "git"
        "networkmanager"
        "gamemode"
        "kvm"
      ];
  };

  # Create ssh sockets directory for controlpaths when homemanager not loaded (i.e. isMinimal)
  systemd.tmpfiles.rules = let
    user = config.users.users.choffmann.name;
    group = config.users.users.choffmann.group;
  in ["d /home/choffmann/.ssh/sockets 0750 ${user} ${group} -"];

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
      hostSpec = config.hostSpec;
    };
    users.${hostSpec.username}.imports = lib.flatten (
      lib.optional (!hostSpec.isMinimal) [
        (
          {config, ...}:
            import (lib.custom.relativeToRoot "home/${hostSpec.username}/${hostSpec.hostName}.nix") {
              inherit
                pkgs
                inputs
                config
                lib
                hostSpec
                ;
            }
        )
      ]
    );
  };

  home-manager.users.root = {
    home.stateVersion = "24.11";
    programs.zsh.enable = true;
  };
}
