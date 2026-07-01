{
  pkgs,
  config,
  inputs,
  ...
}:
let
  shared = import ./shared-browser-config.nix { inherit pkgs config inputs; };
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  stylix.targets.zen-browser.profileNames = [ "choffmann" ];

  programs.zen-browser = {
    enable = true;
    policies = shared.policies;
    profiles.choffmann = {
      id = 0;
      name = "Cedrik";
      isDefault = true;

      extensions.packages = shared.extensions;

      inherit (shared) bookmarks settings search;

      containersForce = true;
      inherit (shared) containers;
    };
  };
}
