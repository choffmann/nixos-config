{...}: {
  imports = [
    ./tpp.nix
  ];

  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autocd = true;
    initExtra = builtins.readFile ./scripts/git_clone_with_fzf.sh;
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
      vi = "nvim";
      vim = "nvim";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  };
}
