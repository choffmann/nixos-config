{
  config,
  lib,
  ...
}:
{
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

    ## User Preferances
    - No Co-Authored-By or author name in commit messages

     ## Git Hygiene
    - Never use `git add -A` or `git add .` - stage files explicitly to avoid committing unrelated changes
    - Verify the target branch before committing (especially for hotfixes/license/main-branch changes)
    - Split unrelated changes into separate commits

    ## Planning First
    Before creating Jira tickets, implementing features, or making non-trivial changes, always present a plan first and wait for approval. Do not jump straight to execution.

    ## Refactoring section

    ### Avoid Sed-Based Refactors
    Do not use sed for multi-file code refactors (import rewrites, struct/function changes). Use Edit tool or AST-aware tooling instead - sed has repeatedly mangled struct fields, function definitions, and string literals.


    ## Writing & Documentation section

    ### No Fabricated Claims
    When writing application/marketing/grant text, only state facts verifiable from the codebase or provided sources. If unsure about a technical claim (e.g., architecture properties, sustainability features), ask before writing it.

  '';

  config.home.file.".claude/CLAUDE.md".text = config.claude.instructions;
}
