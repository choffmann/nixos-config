{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      lg = "lazygit";
      vim = "nvim";
      vi = "nvim";
      switch = "sudo nixos-rebuild switch";
      update = "cd ~/.config/nixos-config/ && sudo nix flake update";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };
}
