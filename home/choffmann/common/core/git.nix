{
  pkgs,
  lib,
  config,
  ...
}:
let
  claudeSigningKey = "${config.home.homeDirectory}/.ssh/id_claude_signing";
  claudeSigningPubKey = lib.custom.relativeToRoot "hosts/common/users/choffmann/keys/id_claude_signing.pub";
in
{
  home.packages = [
    pkgs.difftastic
    pkgs.glab
  ];

  programs.lazygit = {
    enable = true;
    package = pkgs.unstable.lazygit;
    settings = {
      services = {
        "git.progeek.de:2222" = "gitea:git.progeek.de";
      };
      git.overrideGpg = false;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      syntax-theme = "base16";
      dark = true;
      hyperlinks = true;
    };
  };

  programs.git = {
    enable = true;
    signing.key = "3BC97278FCE8CD8D";
    settings = {
      user = {
        email = lib.mkDefault "dev@choffmann.io";
        name = lib.mkDefault "Cedrik Hoffmann";
      };
      alias = {
        fixup = "!git log --oneline --no-decorate --no-merges | fzf -0 --preview 'git show --color=always --format=oneline {1}' | awk '{print $1}' | xargs -r git commit --fixup";
        # Claude Code commits through this instead of `git commit`, so its work
        # stays signed while the yubikey is pulled. Plain `git commit` keeps
        # going through the card.
        agent-commit = "!git -c gpg.format=ssh -c user.signingkey=${claudeSigningKey} -c commit.gpgsign=true commit";
      };
      commit.gpgsign = true;
      tag.gpgsign = true;
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
      pull.rebase = "true";
      rebase.autostash = true;
      rebase.autosquash = true;
      diff.algorithm = "histogram";
      diff.tool = "difftastic";
      difftool.prompt = false;
      "difftool \"difftastic\"".cmd = "difft \"$LOCAL\" \"$REMOTE\"";
      merge.conflictstyle = "zdiff3";
      push.autoSetupRemote = true;
      rerere.enabled = true;
      fetch.prune = true;
      branch.sort = "-committerdate";
      url = {
        # "ssh://git@github.com" = {
        #   insteadOf = "https://github.com";
        # };
        "ssh://git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
        "ssh://gitea@git.progeek.de:2222" = {
          insteadOf = "https://git.progeek.de";
        };
      };
    };
    ignores = [
      ".direnv"
      ".pre-commit-config.yaml"
      "CLAUDE.md"
      ".claude"
      "docs/superpowers/**"
    ];
  };

  # Lets `git log --show-signature` verify the agent's commits locally. Only
  # ssh-format signatures are looked up here; the yubikey ones stay with gpg.
  home.file.".ssh/allowed_signers".text = ''
    dev@choffmann.io,choffmann@progeek.de,cedrik.hoffmann@hs-flensburg.de namespaces="git" ${lib.removeSuffix "\n" (builtins.readFile claudeSigningPubKey)}
  '';

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  # https://joinemm.dev/blog/yubikey-nixos-guide
  programs.gpg = {
    enable = true;

    # https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
    scdaemonSettings = {
      disable-ccid = true;
    };

    # https://github.com/drduh/config/blob/master/gpg.conf
    settings = {
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      fixed-list-mode = true;
      no-comments = true;
      no-emit-version = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      use-agent = true;
      throw-keyids = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;

    # https://github.com/drduh/config/blob/master/gpg-agent.conf
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    pinentry.package = pkgs.pinentry-curses;
    enableExtraSocket = true;
    extraConfig = ''
      ttyname $GPG_TTY
    '';
  };
}
