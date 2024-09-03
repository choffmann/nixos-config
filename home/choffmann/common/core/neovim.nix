{pkgs, inputs, config, ...}:
{
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink inputs.neovim;

  home.packages = with pkgs; [
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
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
}
