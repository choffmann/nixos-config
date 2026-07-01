{
  pkgs,
  config,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  sopsDir = "${homeDir}/.config/sops-nix/secrets";
  kubeDir = "${homeDir}/.kube";
  kubeConfig = "${kubeDir}/config";
  kubeconfigs = [
    "${sopsDir}/k8s/config/green-ecolution"
    "${sopsDir}/k8s/config/k3s-cluster"
    "${sopsDir}/k8s/config/progeek-utility"
    "${sopsDir}/k8s/config/homelab"
    "/var/lib/k8s-oidc-auth/kubeconfig"
  ];
  mergeScript = pkgs.writeShellScript "merge-kubeconfig" ''
    mkdir -p ${kubeDir}
    export KUBECONFIG=${builtins.concatStringsSep ":" kubeconfigs}
    ${pkgs.kubectl}/bin/kubectl config view --flatten > ${kubeConfig}
    chmod 600 ${kubeConfig}
  '';
in
{
  sops.secrets."k8s/config/green-ecolution" = { };
  sops.secrets."k8s/config/k3s-cluster" = { };
  sops.secrets."k8s/config/progeek-utility" = { };
  sops.secrets."k8s/config/homelab" = { };

  home.sessionVariables.KUBECONFIG = kubeConfig;

  systemd.user.services.merge-kubeconfig = {
    Unit = {
      Description = "Merge kubeconfig from sops secrets";
      After = [ "sops-nix.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${mergeScript}";
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.packages = with pkgs; [
    kubectl
    doctl
    kubectx
    minikube
    argocd
    kubernetes-helm
  ];

  programs.k9s.enable = true;
}
