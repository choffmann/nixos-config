{ pkgs, ... }: {
  home.packages = with pkgs; [
    opentofu
    openbao
    kustomize
    ansible
    ansible-lint
    bun
  ];
}
