{
  pkgs,
  config,
  hostSpec,
  ...
}:
let
  # Plain Lua config lives in the repo and is symlinked to ~/.config/nvim,
  # so it stays editable without a rebuild.
  nvimConfig = "${hostSpec.flake}/home/neovim";
  colors = config.lib.stylix.colors;
in
{
  # colors are wired up manually via stylix-colors.lua below;
  # the stylix target would inject a second mini.nvim as pack plugin
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = false;
    withRuby = false;
    # load generated config (providers etc.) via wrapper args instead of
    # writing ~/.config/nvim/init.lua, which would clash with the symlink
    sideloadInitLua = true;

    # lua libraries on nvim's package.path (jsregexp for luasnip)
    extraLuaPackages = ps: [ ps.jsregexp ];

    # Everything the Lua config expects at runtime is provided here.
    # These end up on nvim's wrapper PATH only, not in the user profile.
    extraPackages = with pkgs; [
      # build deps for lazy.nvim, treesitter parsers and luasnip
      gcc
      gnumake
      tree-sitter
      lua51Packages.lua
      luarocks

      # integrations
      wl-clipboard
      manix

      # language servers
      astro-language-server
      gopls
      kotlin-language-server
      lua-language-server
      marksman
      nixd
      rust-analyzer
      tailwindcss-language-server
      tinymist
      typescript # provides tsserver for typescript-language-server
      typescript-language-server
      vscode-langservers-extracted # jsonls, html, css
      yaml-language-server
      zls

      # language toolchains used by the servers above
      go # also provides gofmt for conform
      rustc
      cargo

      # go tools for gopher.nvim
      gomodifytags
      gotests
      impl
      iferr

      # debuggers
      delve
      lldb

      # formatters / linters
      alejandra
      markdown-toc
      markdownlint-cli2
      prettierd
      stylua
      typstyle
    ];
  };

  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink nvimConfig;

  # Stylix base16 palette for the colorscheme, loaded via
  # `require("stylix-colors")` — stdpath("data")/site is on the runtimepath.
  xdg.dataFile."nvim/site/lua/stylix-colors.lua".text = ''
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
