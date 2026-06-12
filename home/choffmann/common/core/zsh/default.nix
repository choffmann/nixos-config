{config, ...}: {
  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    autosuggestion.enable = true;
    autocd = true;
    initContent =
      ''
        [[ "$TERM" == "xterm-ghostty" ]] && ! infocmp xterm-ghostty &>/dev/null && export TERM=xterm-256color
      ''
      + builtins.readFile ./scripts/git_clone_with_fzf.sh;
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
      lzd = "lazydocker";
      gdt = "git difftool";
      cc = "nix run github:sadjow/claude-code-nix --";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  };
}
