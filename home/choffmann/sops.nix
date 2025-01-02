{pkgs, inputs, config, ...}:
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
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";

    secrets = {
      "ssh_keys/choffmann" = {
        path = "${homeDir}/.ssh/id_choffmann";
      };
      "ssh_keys/yubi" = {
        path = "${homeDir}/.ssh/id_yubi";
      };
    };
  };
}
