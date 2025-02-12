{
  pkgs,
  config,
  hostSpec,
  ...
}: let
  nvimConfig = "${hostSpec.flake}/home/neovim";
in {
  home.packages = with pkgs; [
    gcc
    gnumake
    neovim-node-client
    tree-sitter
    manix
    neovim
    wl-clipboard
    lua51Packages.lua
    luarocks
    nodejs

    # lsp
    lua-language-server
    gopls
    typescript
    typescript-language-server
    tailwindcss-language-server
    vscode-langservers-extracted # jsonls
    yaml-language-server
    rust-analyzer
    rustc
    cargo
    nixd
    zls

    # formatter
    stylua
    prettierd
    alejandra
  ];

  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink nvimConfig;
  };
}
