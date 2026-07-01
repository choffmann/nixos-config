# Developer tooling: formatter (nixfmt via treefmt), pre-commit hooks, dev shell.
{...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    # treefmt owns formatting only; exposes `nix fmt` + checks.formatting.
    treefmt = {
      projectRootFile = "flake.nix";
      programs.nixfmt.enable = true; # 26.05: pkgs.nixfmt == RFC 166 formatter
    };

    # git-hooks: runs on commit AND under `nix flake check` (checks.pre-commit).
    pre-commit.settings.hooks = {
      treefmt.enable = true; # format check (single source of truth)
      statix.enable = true; # nix anti-pattern lints
      deadnix.enable = true; # dead bindings / unused args
    };

    devShells.default = pkgs.mkShell {
      shellHook = config.pre-commit.installationScript; # installs the git hook on entry
      packages = with pkgs; [nh sops ssh-to-age nixfmt statix deadnix];
    };
  };
}
