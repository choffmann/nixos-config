{config, ...}: {
  sops.secrets."homeVPN/vpn.conf" = {
    sopsFile = ../../../secrets/vpn.yaml;
    owner = "choffmann";
  };

  sops.secrets."homeVPN/credentials.auth" = {
    sopsFile = ../../../secrets/vpn.yaml;
    owner = "choffmann";
  };

  services.openvpn.servers = {
    homeVPN = {config = ''config ${config.sops.secrets."homeVPN/vpn.conf".path} '';};
  };
}
