{
  pkgs,
  config,
  lib,
  ...
}:
{
  networking.networkmanager.ensureProfiles.profiles = {
    br0 = {
      connection = {
        id = "br0";
        type = "bridge";
        interface-name = "br0";
        autoconnect = "true";
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        method = "disabled";
      };
      bridge = {
        stp = "false";
      };
      ethernet = {
        cloned-mac-address = "60:CF:84:AA:6C:3E";
      };
    };

    br0-eno1 = {
      connection = {
        id = "br0-eno1";
        type = "ethernet";
        interface-name = "eno1";
        master = "br0";
        slave-type = "bridge";
        autoconnect = "true";
      };
      ethernet = {
        wake-on-lan = "64";
      };
    };
  };

  # libvirt bridge network
  systemd.services.libvirt-bridge-network = {
    description = "Define libvirt bridge network";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script =
      let
        bridgeXml = pkgs.writeText "bridge-network.xml" ''
          <network>
            <name>br0</name>
            <forward mode="bridge"/>
            <bridge name="br0"/>
          </network>
        '';
      in
      ''
        ${pkgs.libvirt}/bin/virsh net-info br0 >/dev/null 2>&1 && exit 0
        ${pkgs.libvirt}/bin/virsh net-define ${bridgeXml}
        ${pkgs.libvirt}/bin/virsh net-start br0
        ${pkgs.libvirt}/bin/virsh net-autostart br0
      '';
  };
}
