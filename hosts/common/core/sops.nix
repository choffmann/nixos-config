{
  config,
  ...
}:
{
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    secrets = {
      "netrc" = {
        owner = config.users.users.choffmann.name;
        inherit (config.users.users.choffmann) group;
        path = "/etc/nix/netrc";
      };
      "user_age_keys/keys.txt" = {
        owner = config.users.users.choffmann.name;
        inherit (config.users.users.choffmann) group;
        path = "/home/choffmann/.config/sops/age/keys.txt";
      };
      "yubico/u2f_keys" = {
        owner = config.users.users.choffmann.name;
        inherit (config.users.users.choffmann) group;
        path = "/home/choffmann/.config/Yubico/u2f_keys";
      };
    };
  };

  system.activationScripts.sopsSetAgeKeyOwnership =
    let
      ageFolder = "/home/choffmann/.config/sops/age";
      user = config.users.users.choffmann.name;
      group = config.users.users.choffmann.group;
    in
    ''
      mkdir -p ${ageFolder} || true
      chown -R ${user}:${group} /home/choffmann/.config
    '';
}
