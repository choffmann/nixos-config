{
  pkgs,
  config,
  hostSpec,
  ...
}:
let
  nvimConfig = "${hostSpec.flake}/home/neovim";
  colors = config.lib.stylix.colors;
in
{
  home.packages = with pkgs; [
    unstable.neovim # for latest version

    gcc
    gnumake
    neovim-node-client
    tree-sitter
    manix
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
    astro-language-server

    # debugger
    delve
    lldb

    # formatter
    stylua
    prettierd
    alejandra
    vimPlugins.vim-markdown-toc
  ];

  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink nvimConfig;

  xdg.dataFile."nvim/lua/stylix-colors.lua".text = ''
    return {
      base00 = "#${colors.base00}",
      base01 = "#${colors.base01}",
      base02 = "#${colors.base02}",
      base03 = "#${colors.base03}",
      base04 = "#${colors.base04}",
      base05 = "#${colors.base05}",
      base06 = "#${colors.base06}",
      base07 = "#${colors.base07}",
      base08 = "#${colors.base08}",
      base09 = "#${colors.base09}",
      base0A = "#${colors.base0A}",
      base0B = "#${colors.base0B}",
      base0C = "#${colors.base0C}",
      base0D = "#${colors.base0D}",
      base0E = "#${colors.base0E}",
      base0F = "#${colors.base0F}",
    }
  '';
}
