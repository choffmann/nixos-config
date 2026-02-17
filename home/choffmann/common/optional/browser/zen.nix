{
  pkgs,
  config,
  inputs,
  ...
}: let
  shared = import ./shared-browser-config.nix {inherit pkgs config inputs;};
in {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  # Zen reads from ~/.zen/ instead of ~/.config/zen/ (where HM deploys)
  home.file.".zen/profiles.ini" = {
    force = true;
    text = ''
      [General]
      StartWithLastProfile=1
      Version=2

      [Profile0]
      Default=1
      IsRelative=1
      Name=Cedrik
      Path=choffmann
    '';
  };

  stylix.targets.zen-browser.profileNames = ["choffmann"];

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
