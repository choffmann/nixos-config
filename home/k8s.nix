{pkgs, ...}:
{
  sops = {
    age.keyFile = "/home/user/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/k8s/config.yaml;
    secrets.k8s = {
      path = "%r/k8s/config"; 
    };
  };

systemd.services."k8s_cp_conf" = {

}
