{pkgs, lib, ...}:
let
  mergeKubeConfig = pkgs.writeShellScriptBin "merge-kube-config" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Merge all kubeconfig files into one
    # TODO: Make it dynamic
    CONFIGS=(
      k3s_config.yaml
      green-ecolution_config.yaml
    )

    for kubeconfig in "$CONFIGS[@]"; do
      if [ -f "$HOME/$kubeconfig" ]; then
        export KUBECONFIG="$KUBECONFIG:$HOME/.kube/$kubeconfig"
      fi
    done

    kubectl config view --flatten > "$HOME/.kube/config"
    export KUBECONFIG="$HOME/.kube/config"
  '';
in
{
  home.packages = with pkgs; [
    doctl
    kubectl
    kubectx
    minikube
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
    argocd
  ];

  home.activation.mergeKubeConfig = lib.hm.dag.entryAfter ["writeBoundary"] mergeKubeConfig;
}
