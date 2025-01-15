{pkgs, config, lib, ...}:
let
  homeDir = config.home.homeDirectory;
in
{
  sops.secrets."k8s/config/green-ecolution" = {};
  sops.secrets."k8s/config/k3s-cluster" = {};

  home.sessionVariables.KUBECONFIG = "${homeDir}/.kube/config";

  home.activation = {
    mergeKubeConfig = lib.hm.dag.entryAfter [ "sops-nix" ] ''
      mkdir -p ~/.kube

      if [ -f ${homeDir}/.kube/config ]; then
        rm ${homeDir}/.kube/config
      fi

      export PATH=${pkgs.kubectl}/bin:$PATH
      export KUBECONFIG=${homeDir}/.kube/config:$(find ${homeDir}/.config/sops-nix/secrets/k8s/config -type f | tr '\n' ':')

      kubectl config view --flatten > ${homeDir}/.kube/config
      export KUBECONFIG=${homeDir}/.kube/config
      chmod 700 ${homeDir}/.kube/config
    '';
  };

  home.packages = with pkgs; [ 
    kubectl
    doctl
    kubectx
    minikube
    argocd
    helm
  ];

  programs.k9s.enable = true;
}
