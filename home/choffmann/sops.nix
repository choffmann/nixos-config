{pkgs, inputs, config, ...}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/choffmann/.config/sops/age/keys.txt";

    secrets = {
      "ssh_keys/yubi" = {
        path = "${config.home.homeDirectory}/.ssh/id_yubi";
      };
    };
  };
}
