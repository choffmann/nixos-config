{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./ghostty
    ./nvim
    ./zsh
    ./cli-tools.nix
    ./fonts.nix
    ./git.nix
    ./ssh.nix
  ];

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = "23.05";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      FLAKE = "$HOME/nixos-config";
      SHELL = "zsh";
      TERM = "ghostty";
      TERMINAL = "ghostty";
      VISUAL = "nvim";
      EDITOR = "nvim";
      MANPAGER = "batman";
    };
    preferXdgDirectories = true;
  };

  home.packages = with pkgs; [
    btop # resource monitor
    copyq # clipboard manager
    coreutils # basic gnu utils
    curl
    eza # ls replacement
    dust # disk usage
    fd # tree style ls
    findutils # find
    fzf # fuzzy search
    jq # JSON pretty printer and manipulator
    nix-tree # nix package tree viewer
    neofetch # fancier system info than pfetch
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
