{ config, ... }: {
  sops.secrets."homeVPN/vpn.conf" = {
    sopsFile = ../../../secrets/vpn.yaml;
    owner = "choffmann";
  };

  sops.secrets."homeVPN/credentials.auth" = {
    sopsFile = ../../../secrets/vpn.yaml;
    owner = "choffmann";
  };

  sops.secrets."office/vpn.conf" = {
    sopsFile = ../../../secrets/vpn.yaml;
    owner = "choffmann";
  };

  services.openvpn.servers = {
    homeVPN = {
      autoStart = false;
      config = "config ${config.sops.secrets."homeVPN/vpn.conf".path} ";
    };
    office = {
      autoStart = false;
      updateResolvConf = true;
      config = "config ${config.sops.secrets."homeVPN/vpn.conf".path} ";
    };
  };
}
