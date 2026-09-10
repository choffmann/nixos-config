{ pkgs, ... }:
let
  # Claude Code injects a per-turn reminder telling itself to append an
  # attribution trailer. Empty attribution strings suppress that reminder; the
  # hook is the backstop for a message that carries one anyway.
  blockAttribution = pkgs.writeShellApplication {
    name = "claude-block-commit-attribution";
    runtimeInputs = [
      pkgs.jq
      pkgs.gnugrep
    ];
    text = ''
      payload=$(cat)
      cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null || true)

      # Fall back to the raw payload so a parse failure still gets inspected
      if [ -z "$cmd" ]; then
        cmd="$payload"
      fi

      # All three must match, so that writing *about* attribution stays possible
      invokes_vcs='(^|[;&|(]|&&|\|\|)[[:space:]]*(git|jj|hub)[[:space:]]'
      commit_verb='(agent-)?commit([[:space:]]|$)'
      attribution='co-authored-by|noreply@anthropic\.com|generated with[^|]{0,20}claude|assisted-by|claude (opus|sonnet|haiku|code)[^|]{0,20}<'

      if printf '%s' "$cmd" | grep -qiE "$invokes_vcs" \
        && printf '%s' "$cmd" | grep -qiE "$commit_verb" \
        && printf '%s' "$cmd" | grep -qiE "$attribution"; then
        cat <<'JSON'
      {"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked: this commit carries an AI attribution line (Co-Authored-By / Generated with / noreply@anthropic.com). The user forbids any attribution or author name in commit messages. Rewrite the message without that trailer and commit again."}}
      JSON
      fi
      exit 0
    '';
  };

  settingsFormat = pkgs.formats.json { };
in
{
  # Managed settings outrank ~/.claude/settings.json and are the only settings
  # file Claude Code never rewrites itself, so the user file stays mutable for
  # plugins, effort level and theme.
  environment.etc."claude-code/managed-settings.json".source =
    settingsFormat.generate "claude-managed-settings.json"
      {
        attribution = {
          commit = "";
          pr = "";
        };

        hooks.PreToolUse = [
          {
            matcher = "Bash";
            hooks = [
              {
                type = "command";
                command = "${blockAttribution}/bin/claude-block-commit-attribution";
                timeout = 10;
              }
            ];
          }
        ];
      };
}
