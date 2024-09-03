{
  pkgs,
  config,
  configVars,
  ...
}:
let
  handle = configVars.handle;
  publicGitEmail = configVars.gitHubEmail;
  # publicKey = "${config.home.homeDirectory}].ssh/github.pub";
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = handle;
    userEmail = publicGitEmail;
    aliases = { };
    extraConfig = {
      init.defaultBranch = "main";
      # url = {
      #   "ssh://git@github.com" = {
      #     insteadOf = "https://github.com";
      #   };
      #   "ssh://git@gitlab.com" = {
      #     insteadOf = "https://gitlab.com";
      #   };
      # };

      # commit.gpgsign = false;
      # gpg.format = "ssh";
      # user.signing.key = "${publicKey}";
      # Taken from https://github.com/clemak27/homecfg/blob/16b86b04bac539a7c9eaf83e9fef4c813c7dce63/modules/git/ssh_signing.nix#L14
      # gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };
    # signing = {
    #   signByDefault = true;
    #   key = publicKey;
    # };
    ignores = [
      ".direnv"
      "result"
    ];
  };

  # home.file.".ssh/allowed_signers".text = 
  #   let
  #     authorizedKeys = pkgs.fetchurl {
  #       url = "https://github.com/choffmann.keys";
  #       sha256 = "a20843af96a6254e11b8d506a38ee7d8a651280b2397b7abbf5b7f85760da3fe";
  #     };
  #   in
  #   pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
}

