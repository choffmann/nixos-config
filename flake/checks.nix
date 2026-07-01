# Prove every host actually builds via `nix flake check`.
{ self, ... }: {
  perSystem = _: {
    checks = {
      host-cho-progeek = self.nixosConfigurations.cho-progeek.config.system.build.toplevel;
      host-home-pc = self.nixosConfigurations.home-pc.config.system.build.toplevel;
    };
  };
}
