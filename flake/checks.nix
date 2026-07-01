# Prove every host actually builds via `nix flake check`.
{ self, ... }: {
  perSystem = { ... }: {
    checks = {
      host-cho-progeek = self.nixosConfigurations.cho-progeek.config.system.build.toplevel;
      host-home-pc = self.nixosConfigurations.home-pc.config.system.build.toplevel;
    };
  };
}
