{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./ghostty
    ./zsh
    ./neovim.nix
    ./claude.nix
    ./cli-tools.nix
    ./yazi.nix
    ./tmux.nix
    ./fonts.nix
    ./stylix.nix
    ./git.nix
    ./ssh.nix
    ./xdg.nix
  ];

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = "23.05"; # pinned: bumping changes home-manager module defaults
    sessionPath = [
      "/home/choffmann/.local/bin"
    ];
    sessionVariables = {
      NH_FLAKE = "/home/choffmann/nixos-config";
      SHELL = "zsh";
      TERM = "xterm-ghostty";
      TERMINAL = "ghostty";
      VISUAL = "nvim";
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
    preferXdgDirectories = true;
  };

  home.packages = with pkgs; [
    coreutils # basic gnu utils
    curl
    eza # ls replacement
    dust # disk usage
    fd # tree style ls
    findutils # find
    fzf # fuzzy search
    jq # JSON pretty printer and manipulator
    nix-tree # nix package tree viewer
    fastfetch # fancier system info than pfetch
    ncdu # TUI disk usage
    pciutils
    pfetch # system info
    pre-commit # git hooks
    p7zip # compression & encryption
    ripgrep # better grep
    steam-run # for running non-NixOS-packaged binaries on Nix
    usbutils
    tree # cli dir tree viewer
    unzip # zip extraction
    unrar # rar extraction
    xdg-utils # provide cli tools such as `xdg-mime` and `xdg-open`
    xdg-user-dirs
    wev # show wayland events. also handy for detecting keypress codes
    zip # zip compression
    yq-go
    openssl
    wget
    tealdeer # tldr
    tokei
    hyperfine
    doggo
    procs
    bandwhich
    just
    lazydocker
    unstable.claude-code
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
