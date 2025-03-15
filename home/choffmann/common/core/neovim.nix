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
    vscode-langservers-extracted # jsonls, html, css
    yaml-language-server
    rust-analyzer
    rustc
    cargo
    nixd
    zls
    markdownlint-cli2
    marksman

    # formatter
    stylua
    prettierd
    alejandra
    vimPlugins.vim-markdown-toc
  ];

  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink nvimConfig;
  };
}
