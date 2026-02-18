{config, ...}: {
  sops.secrets."k8s/oidc/progeek-staging-server" = {};
  sops.secrets."k8s/oidc/progeek-staging-auth-url" = {};
  sops.secrets."k8s/oidc/progeek-staging-ca" = {};
  sops.secrets."k8s/oidc/progeek-production-server" = {};
  sops.secrets."k8s/oidc/progeek-production-auth-url" = {};
  sops.secrets."k8s/oidc/progeek-production-ca" = {};
  sops.secrets."k8s/oidc/issuer-url" = {};

  programs.kubectl-k8s-oidc-auth = {
    enable = true;
    manageKubeconfig = false;
    clusters."progeek-staging" = {
      serverFile = config.sops.secrets."k8s/oidc/progeek-staging-server".path;
      certificateAuthorityDataFile = config.sops.secrets."k8s/oidc/progeek-staging-ca".path;
      authServiceUrlFile = config.sops.secrets."k8s/oidc/progeek-staging-auth-url".path;
      oidc.issuerUrlFile = config.sops.secrets."k8s/oidc/issuer-url".path;
      oidc.clientId = "k8s-oidc-auth";
    };
    clusters."progeek-production" = {
      serverFile = config.sops.secrets."k8s/oidc/progeek-production-server".path;
      certificateAuthorityDataFile = config.sops.secrets."k8s/oidc/progeek-production-ca".path;
      authServiceUrlFile = config.sops.secrets."k8s/oidc/progeek-production-auth-url".path;
      oidc.issuerUrlFile = config.sops.secrets."k8s/oidc/issuer-url".path;
      oidc.clientId = "k8s-oidc-auth";
    };
  };
}
