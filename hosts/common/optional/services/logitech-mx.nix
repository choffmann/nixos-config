{ inputs, ... }: {
  imports = [
    inputs.solaar.nixosModules.default
  ];

  # udev rules for Logitech wireless devices - enables mouse immediately at boot
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  services.solaar.enable = true;
}
