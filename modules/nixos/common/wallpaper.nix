{ lib, ... }:
{
  options.desktop.wallpaper = lib.mkOption {
    type = lib.types.path;
    description = ''
      Wallpaper for DankMaterialShell and its greeter.

      Deliberately separate from `stylix.image`: the greeter reads this at
      greetd start, long before any user session or stylix state exists.
    '';
  };
}
