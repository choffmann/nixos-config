{pkgs, config, lib, ...}:
let
  homeDir = config.home.homeDirectory;
in
{
  sops.secrets."k8s/config/green-ecolution" = {};

  home.packages = [ pkgs.kubectl ];
  home.sessionVariables.KUBECONFIG = "${homeDir}/.kube/config";

  home.activation = {
    mergeKubeConfig = lib.mkAfter ''
      mkdir -p ~/.kube

      export PATH=${pkgs.kubectl}/bin:$PATH
      export KUBECONFIG=${homeDir}/.kube/config:$(find ${homeDir}/.config/sops-nix/secrets/k8s/config -type f | tr '\n' ':')

      kubectl config view --flatten > ${homeDir}/.kube/config
      export KUBECONFIG=${homeDir}/.kube/config
      chmod 600 ${homeDir}/.kube/config
    '';
  };
}
