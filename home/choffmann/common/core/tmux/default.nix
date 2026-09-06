{
  pkgs,
  config,
  ...
}:
let
  dmsColors = "${config.xdg.configHome}/tmux/dms-colors.conf";

  # matugen post_hook. source-file does not spawn a server, so with no tmux
  # running its failure is the normal case, not an error worth surfacing.
  reload-dms-colors = pkgs.writeShellScript "tmux-reload-dms-colors" ''
    ${config.programs.tmux.package}/bin/tmux source-file ${dmsColors} 2>/dev/null || true
  '';

  tmux-sessionizer = pkgs.writeShellApplication {
    name = "tmux-sessionizer";
    # runtimeInputs = builtins.attrValues {inherit (pkgs) find fzf tmux;};
    text = ''
      #!/usr/bin/env bash

      if [[ $# -eq 1 ]]; then
        selected=$1
      else
          selected=$(find ~/projects ~/projects/personal -mindepth 1 -maxdepth 1 -type d | fzf)
      fi

      if [[ -z "$selected" ]]; then
          exit 0
      fi

      selected_name=$(basename "$selected" | tr . _)
      tmux_running=$(pgrep tmux)

      if [[ -z $TMUX ]] && [[ -z "$tmux_running" ]]; then
          tmux new-session -s "$selected_name" -c "$selected"
          exit 0
      fi

      if ! tmux has-session -t="$selected_name" 2> /dev/null; then
          tmux new-session -ds "$selected_name" -c "$selected"
      fi

      tmux switch-client -t "$selected_name"
    '';
  };
in
{
  home.packages = [
    tmux-sessionizer
  ];

  # DMS merges every toml here into its generated matugen config verbatim,
  # without the SHELL_DIR/CONFIG_DIR substitution its own configs get, so
  # these paths have to be absolute.
  xdg.configFile."matugen/dms/configs/tmux.toml".text = ''
    [templates.tmux]
    input_path = '${./dms-colors.conf}'
    output_path = '${dmsColors}'
    post_hook = '${reload-dms-colors}'
  '';

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    tmuxinator.enable = true;
    shortcut = "Space";
    baseIndex = 1;
    keyMode = "vi";

    extraConfig = ''
      # Status bar position
      set -g status-position bottom

      # Reload config PREFIX + r
      bind r source-file ~/.tmux.conf \; display "Reloaded!"

      # Numbering Windows and Panes
      set -g base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on

      # Split View
      bind | split-window -hc "#{pane_current_path}"
      bind - split-window -vc "#{pane_current_path}"

      # Toggling Windows and Sessions
      bind Space last-window
      bind-key C-Space switch-client -l

      # Kill window and pane without prompt
      bind & kill-window
      bind x kill-pane

      # Set vim keys in copy mode
      set -g mode-keys vi

      # yazi
      set -g allow-passthrough on

      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      set -g status-left-length 30
      set -g status-right-length 30
      set -g window-status-separator " "

      # Colours come from DMS, which regenerates them from the wallpaper via
      # matugen. The file is absent until its first run.
      source -q ${dmsColors}
    '';

    plugins = with pkgs.tmuxPlugins; [
      { plugin = vim-tmux-navigator; }
      { plugin = sensible; }
      { plugin = tmux-fzf; }
    ];
  };
}
