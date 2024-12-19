{pkgs, ...}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -lah";
      lg = "lazygit";
      switch = "sudo nixos-rebuild switch";
      update = "sudo nix-channel --update && sudo nixos-rebuild switch";
      k = "kubectl";
      kctx = "kubectx";
      clr = "clear";
      open = "xdg-open";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  };
}
