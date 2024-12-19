{pkgs, config, lib, ...}:
let
  homeDir = config.home.homeDirectory;
in
{
  sops.secrets."k8s/config/green-ecolution" = {};

  home.sessionVariables.KUBECONFIG = "${homeDir}/.kube/config";

  home.activation = {
    mergeKubeConfig = lib.hm.dag.entryAfter [ "sops-nix" ] ''
      mkdir -p ~/.kube

      export PATH=${pkgs.kubectl}/bin:$PATH
      export KUBECONFIG=${homeDir}/.kube/config:$(find ${homeDir}/.config/sops-nix/secrets/k8s/config -type f | tr '\n' ':')

      kubectl config view --flatten > ${homeDir}/.kube/config
      export KUBECONFIG=${homeDir}/.kube/config
      chmod 600 ${homeDir}/.kube/config
    '';
  };

  home.packages = with pkgs; [ 
    kubectl
    doctl
    kubectx
    minikube
  ];

  programs.k9s.enable = true;
}
