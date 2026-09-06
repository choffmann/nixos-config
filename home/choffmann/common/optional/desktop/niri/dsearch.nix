{ inputs, ... }:
{
  imports = [ inputs.danksearch.homeModules.dsearch ];

  # DMS's launcher only probes for the binary on PATH, but every query goes
  # through dsearch's local API server, so the module's user unit is what
  # actually makes file results appear.
  programs.dsearch.enable = true;
}
