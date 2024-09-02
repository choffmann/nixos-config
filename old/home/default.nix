# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    ./neovim
    ./i3
    ./console-tools.nix
    ./wallpaper
    ./zsh.nix
    ./tmux.nix
    ./alacritty.nix
    ./chromium.nix
    ./rofi.nix
    ./k8s.nix
  ];

  home = {
    inherit username;
    homeDirectory = lib.mkForce "/home/${username}";
  };

  programs.git = {
    enable = true;

    difftastic = {
      enable = true;
    };

    package = pkgs.gitFull;

    extraConfig = {
      merge.tool = "nvim";
      mergetool = {
        keepBackup = false;
        prompt = false;
      };
      mergetool.nvim = {
        cmd = "${lib.getExe pkgs.neovim} -d -c \"wincmd l\" -c \"norm ]c\" \"$LOCAL\" \"$MERGED\" \"$REMOTE\"";
      };
      init.defaultBranch = "develop";
      pull.ff = "true";
      pull.rebase = "true";
      merge.conflictstyle = "zdiff3";
      credential.helper = "libsecret";
    };
  };

  services.gnome-keyring.enable = true;
  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

  home.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
