{pkgs, inputs, outputs, config, ...}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  pubKeys = pkgs.fetchurl {
    url = "https://github.com/choffmann.keys";
    sha256 = "a20843af96a6254e11b8d506a38ee7d8a651280b2397b7abbf5b7f85760da3fe";
  };
in
{
  users.users.choffmann = {
    initialPassword = "geheim";
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile pubKeys);
    extraGroups =
      [ "wheel" ]
      ++ ifTheyExist [
        "docker"
        "git"
        "networkmanager"
      ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      choffmann = import ../../../home-manager/home.nix;
    };
  };
}
