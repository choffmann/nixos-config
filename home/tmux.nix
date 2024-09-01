{pkgs, ...}:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.sensible
      tmuxPlugins.catppuccin
    ];
    extraConfig = ''
      # Reload config PREFIX + r
      bind r source-file ~/.tmux.conf \; display "Reloaded!"

      # Set Colors in tmux
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Prefix to CTRL + SPACE
      unbind C-Space
      set -g prefix C-Space
      bind C-Space send-prefix

      # Enable mouse support
      set -g mouse on

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
    '';
  };

  home.packages = [
    # Open tmux for current project.
    (pkgs.writeShellApplication {
      name = "pux";
      runtimeInputs = [ pkgs.tmux ];
      text = ''
        PRJ="''$(zoxide query -i)"
        echo "Launching tmux for ''$PRJ"
        set -x
        cd "''$PRJ" && \
          exec tmux -S "''$PRJ".tmux attach
      '';
    })
  ];
}
