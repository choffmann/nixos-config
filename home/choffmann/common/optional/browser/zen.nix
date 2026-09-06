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

  programs.zen-browser = {
    enable = true;
    inherit (shared) policies;
    profiles.choffmann = {
      id = 0;
      name = "Cedrik";
      isDefault = true;

      extensions.packages = shared.extensions;

      # DMS regenerates this from the wallpaper via matugen.
      userChrome = ''
        @import url("file://${config.home.homeDirectory}/.config/DankMaterialShell/zen.css");
      '';

      inherit (shared) bookmarks settings search;

      containersForce = true;
      inherit (shared) containers;
    };
  };
}
