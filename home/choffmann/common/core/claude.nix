{
  config,
  lib,
  ...
}: {
  options.claude.instructions = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Instructions for Claude Code (~/.claude/CLAUDE.md)";
  };

  config.claude.instructions = lib.mkBefore ''
    - Dies ist ein NixOS-System. Nutze `nix-shell -p <package>` oder `nix shell nixpkgs#<package>` fuer temporaer benoetigte Pakete
    - `cd` ist mit zoxide aliased. Nutze `builtin cd` oder gib Pfade direkt im Befehl an
    - `builtin` funktioniert nur mit Shell-Builtins. NIEMALS `builtin pnpm`, `builtin go`, etc.
    - Kommentiere nur wenn noetig, in Englisch, kurz und knackig
    - Schreibe nicht deinen Namen in Commit-Messages
  '';

  config.home.file.".claude/CLAUDE.md".text = config.claude.instructions;
}
