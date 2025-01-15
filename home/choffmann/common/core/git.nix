{lib, ...}: {
  programs.lazygit.enable = true;
  programs.git = {
    enable = true;
    userEmail = lib.mkDefault "dev@choffmann.io";
    userName = lib.mkDefault "Cedrik Hoffmann";
    extraConfig = {
      pull.rebase = "true";
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
        "ssh://git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
      };
    };
    ignores = [
      ".direnv"
    ];
  };
}
