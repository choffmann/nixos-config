{ lib, configVars, ... }:
{
  imports = [
    #################### Hardware Modules ####################
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-cpu-intel
    # inputs.hardware.nixosModules.common-gpu-nvidia
    # inputs.hardware.nixosModules.common-gpu-intel
    # inputs.hardware.nixosModules.common-pc-ssd

    #################### Required Configs ####################
    ./common/core # required

    #################### Host-specific Optional Configs ####################
    ./common/optional/desktops/i3
  ];

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };

  # Disable impermanence
  #home.persistence = lib.mkForce { };
}
