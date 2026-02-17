{
  pkgs,
  config,
  lib,
  ...
}: {
  networking = {
    bridges.br0.interfaces = ["eno1"];

    interfaces = {
      eno1 = {
        useDHCP = false;
        wakeOnLan.enable = true;
      };
      br0.useDHCP = true;
    };
  };

  # Ensure bridge is up before libvirt
  systemd.services."network-addresses-br0".before = ["libvirtd.service"];

  # libvirt bridge network
  systemd.services.libvirt-bridge-network = {
    description = "Define libvirt bridge network";
    after = ["libvirtd.service"];
    requires = ["libvirtd.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = let
      bridgeXml = pkgs.writeText "bridge-network.xml" ''
        <network>
          <name>br0</name>
          <forward mode="bridge"/>
          <bridge name="br0"/>
        </network>
      '';
    in ''
      ${pkgs.libvirt}/bin/virsh net-info br0 >/dev/null 2>&1 && exit 0
      ${pkgs.libvirt}/bin/virsh net-define ${bridgeXml}
      ${pkgs.libvirt}/bin/virsh net-start br0
      ${pkgs.libvirt}/bin/virsh net-autostart br0
    '';
  };
}
