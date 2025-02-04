{
  pkgs,
  lib,
  ...
}: let
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
in {
  home.packages = [
    tmux-sessionizer
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {};
  };

  programs.bat = {
    enable = true;
    config = {
      # Show line numbers, Git modifications and file header (but no grid)
      style = "numbers,changes,header";
      #      theme = "";
    };
    extraPackages = builtins.attrValues {
      inherit
        (pkgs.bat-extras)
        batgrep # search through and highlight files using ripgrep
        batdiff # Diff a file against the current git index, or display the diff between to files
        batman
        ; # read manpages using bat as the formatter
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd" # replace cd with z and zi (via cdi)
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # better than native direnv nix functionality - https://github.com/nix-community/nix-direnv
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    keymap = {
      manager.prepend_keymap = [
        {
          on = ["!"];
          run = "shell \"$SHELL\" --block --confirm";
          desc = "Open shell here";
        }
        {
          on = ["<Esc>"];
          run = "close";
          desc = "Cancel input";
        }
      ];
    };
    settings = {
      manager = {
        show_hidden = true;
      };
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    shell = "${pkgs.zsh}/bin/zsh";
    tmuxinator.enable = true;
    shortcut = "Space";
    baseIndex = 1;
    keyMode = "vi";

    extraConfig = ''
      # Reload config PREFIX + r
      bind r source-file ~/.tmux.conf \; display "Reloaded!"

      # Set Colors in tmux
      # set-option -sa terminal-overrides ",xterm*:Tc"

      # Prefix to CTRL + SPACE
      # unbind C-Space
      # set -g prefix C-Space
      # bind C-Space send-prefix

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

    plugins = with pkgs.tmuxPlugins; [
      {plugin = vim-tmux-navigator;}
      {plugin = sensible;}
      {plugin = tmux-fzf;}
      {plugin = catppuccin;}
    ];
  };
}
