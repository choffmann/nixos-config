{ config, pkgs, inputs, ... }:
{
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink inputs.neovim;

  home.packages = with pkgs; [
    neovim
    go
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
    neovim-node-client
    tree-sitter
    lua
    luarocks
    neovide
  ];

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
}
