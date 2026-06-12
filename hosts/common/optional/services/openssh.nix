{
  pkgs,
  lib,
  config,
  ...
}: let
  sshPort = 22;
  yubikeyPubKey = lib.custom.relativeToRoot "hosts/common/users/choffmann/keys/id_yubi.pub";
in {
  services.openssh = {
    enable = true;
    startWhenNeeded = true;

    ports = [sshPort];
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };
  };

  security.pam.services.sudo = {config, ...}: {
    rules.auth.rssh = {
      order = 10500;
      control = "sufficient";
      modulePath = "${pkgs.pam_rssh}/lib/libpam_rssh.so";
      settings.authorized_keys_command = pkgs.writeShellScript "get-authorized-keys" ''
        cat "${yubikeyPubKey}"
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [sshPort];
}
