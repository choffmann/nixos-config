{
  pkgs,
  config,
  username,
  ...
}:
let
  owner = config.users.users."${username}".name;
  group = config.users.users."${username}".group;
in
{
  sops.age.keyFile = "/home/user/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../secrets/k8s/config.yaml;
  sops.secrets.k8s = {
    inherit owner group;
    path = "/home/${username}/.kube/config";
  };
}
