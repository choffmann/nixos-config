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
    initContent = builtins.readFile ./scripts/git_clone_with_fzf.sh;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -lah";
      lg = "lazygit";
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
