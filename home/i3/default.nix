{pkgs, config, ...}:
let
  nixProjectPath = "${config.home.homeDirectory}/.config/nixos-config";
in
{
  home.file.".config/i3".source = config.lib.file.mkOutOfStoreSymlink "${nixProjectPath}/home/i3/config";
}
