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

  # home.file.".claude/commands/review-text.md".text = ''
  #   Du bist ein kritischer Lektor für professionelle Texte.
  #
  #     ## Aufgabe
  #
  #     Lies die Datei unter $ARGUMENTS und prüfe sie systematisch gegen die folgenden Qualitätskriterien.
  #
  #     ## Prüfkriterien
  #
  #     ### Formulierung und Schreibstil
  #     - Ist der Ton professionell und sachlich, neutral-freundlich aber nicht überschwänglich?
  #     - Werden Fließtexte bevorzugt? Lesen sich die Texte natürlich, wie von einem Menschen geschrieben?
  #     - Wird Fettschrift sparsam und gezielt eingesetzt?
  #     - Werden Gedankenstriche vermieden?
  #     - Werden Aufzählungen mit Bedacht eingesetzt (nicht zu häufig)?
  #     - Werden Tabellen mit Bedacht eingesetzt?
  #
  #     ### Formatierung und Struktur
  #     - Ist die Gliederung sinnvoll und logisch aufgebaut?
  #     - Sind Überschriften-Ebenen konsistent?
  #     - Gibt es Formatierungsprobleme?
  #
  #     ### Inhaltliche Qualität
  #     - Gibt es unnötige Redundanzen (gleiche Information mehrfach genannt)?
  #     - Gibt es überflüssige Textpassagen die keinen Mehrwert bringen?
  #     - Gibt es umfangreiche Ausschweifungen die gekürzt werden sollten?
  #     - Sind Formulierungen zu überschwänglich oder angeberisch?
  #     - Werden Erfolge und Ergebnisse professionell dargestellt?
  #     - Stimmt die Flughöhe (nicht zu detailliert, nicht zu oberflächlich)?
  #
  #     ### Sprache
  #     - Gibt es Grammatik- oder Rechtschreibfehler?
  #     - Sind Fachbegriffe korrekt und konsistent verwendet?
  #     - Gibt es unnötige Anglizismen oder Füllwörter?
  #     - Ist der Text frei von typischen KI-Formulierungen (z.B. "Es ist wichtig zu beachten", "Darüber hinaus", übermäßige Aufzählungen)?
  #
  #     ## Ausgabeformat
  #
  #     Gliedere den Bericht nach Abschnitten des Dokuments. Innerhalb jedes Abschnitts nach Priorität (hoch/mittel/niedrig) sortieren:
  #
  #     ### Abschnitt: [Name]
  #
  #     **Hoch:**
  #     - [Befund + Zitat + Problem + Verbesserungsvorschlag]
  #
  #     **Mittel:**
  #     - ...
  #
  #     **Niedrig:**
  #     - ...
  #
  #     Für jeden Befund:
  #     - Zitiere den betroffenen Textabschnitt
  #     - Beschreibe das Problem
  #     - Schlage eine konkrete Verbesserung vor
  #
  #     Abschnittübergreifende Befunde (z.B. Redundanzen zwischen Abschnitten) in einem eigenen Abschnitt "Übergreifend" am Ende aufführen. Abschließend eine
  #     Zusammenfassungstabelle aller Befunde mit Priorität.
  # '';

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
        - Commit messages are always written in English and follow Conventional Commits (`type(scope): summary`), unless the project already prescribes a different convention - then follow the project's convention

        ## Planning First
        Before creating Jira tickets, implementing features, or making non-trivial changes, always present a plan first and wait for approval. Do not jump straight to execution.

        ## Refactoring section

        ### Avoid Sed-Based Refactors
        Do not use sed for multi-file code refactors (import rewrites, struct/function changes). Use Edit tool or AST-aware tooling instead - sed has repeatedly mangled struct fields, function definitions, and string literals.


        ## Writing & Documentation section

        ### No Fabricated Claims
        When writing application/marketing/grant text, only state facts verifiable from the codebase or provided sources. If unsure about a technical claim (e.g., architecture properties, sustainability features), ask before writing it.

      ## Schreibstil für Texte und Dokumente

      Beim Verfassen von Texten (Berichte, Dokumentation, Beschreibungen) gelten folgende Richtlinien:

      - Professionell und sachlich schreiben. Der Ton ist neutral-freundlich, nicht überschwänglich.
      - Fließtexte werden stark bevorzugt. Natürlich formulieren, wie ein Mensch es schreiben würde.
      - Fettschrift sparsam und gezielt einsetzen, nicht großflächig.
      - Auf Formulierungen mit Gedankenstrichen weitestgehend verzichten.
      - Aufzählungen sind erlaubt, aber mit Bedacht und nicht zu häufig nutzen.
      - Tabellen und Diagramme sind in Ordnung, aber ebenfalls mit Bedacht einsetzen.
      - Der Fokus liegt auf natürlichen, gut lesbaren Texten.

      ## Code-Kommentare

    Standardmäßig keine Kommentare. Code soll sich durch sprechende Namen
    selbst erklären. Schreibe nur dann einen Kommentar, wenn das **WARUM**
    nicht-offensichtlich ist und der Leser ohne den Kommentar in eine Falle
    laufen würde.

    **Behalten:**
    - Versteckte Constraints oder Invarianten, die der Code nicht zeigt
      (z. B. „Reihenfolge wichtig wegen UNIQUE-Index").
    - Workarounds für konkrete Bugs/Quirks externer Systeme.
    - Verhalten, das einen erfahrenen Leser überraschen würde.
    - Verweise auf Hardware-Fakten oder externe Verträge, die nicht aus
      dem Code ablesbar sind.

    **Streichen:**
    - „Was macht der Code"-Kommentare. Wenn der Kommentar nur den nächsten
      Ausdruck paraphrasiert, ist er Lärm.
    - Kommentare, die den aktuellen Task beschreiben („Added for #123",
      „used by X"). Das gehört in die Commit-Message oder PR-Beschreibung.
    - Section-Banner / dekorative Trennlinien.
    - Doc-Comments, die nur die Type-Signatur wiederholen.
    - TODO/FIXME ohne Owner und konkreten Kontext.

    **Form:**
    - Kurz und knackig. Eine Zeile ist meist genug, maximal zwei bis drei.
    - Englisch.
    - Keine mehrzeiligen Doc-Blöcke, in denen jeder Parameter erklärt wird,
      wenn der Name bereits klar ist.

    Im Zweifel: keinen Kommentar schreiben. Lieber einen Variablen- oder
    Funktionsnamen verbessern, der die Frage gar nicht erst aufwirft.
  '';

  config.home.file.".claude/CLAUDE.md".text = config.claude.instructions;
}
