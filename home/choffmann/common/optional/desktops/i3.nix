{ pkgs, config, inputs, ... }:
{
  home.file.".config/i3".source = config.lib.file.mkOutOfStoreSymlink "${inputs.dotfiles}/.config/i3";
}
