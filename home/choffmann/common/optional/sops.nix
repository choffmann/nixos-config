{pkgs, inputs, config, ...}:
let
  homeDirectory = config.home.homeDirectory;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";

    defaultSopsFile = "../../../../secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      k8s.config = {
        k3s.path = "${homeDirectory}/.kube/k3s_config.yaml";
        green-ecolution.path = "${homeDirectory}/.kube/green-ecolution_config.yaml";
      };
    };
  };
}
