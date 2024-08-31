{ config, pkgs, ...}: 
let
  nixProjectPath = "${config.home.homeDirectory}/.config/nixos-config";
in
{
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${nixProjectPath}/home/neovim/config";
  home.packages = with pkgs; [
    neovim
    go
    ripgrep
    gnumake
    rustc
    cargo
    python3
    nodejs
    yarn
    lazygit
    fzf
    gcc
    sqlite
    unzip
  ];

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
}
