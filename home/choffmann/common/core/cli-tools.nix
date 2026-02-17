{
  pkgs,
  lib,
  config,
  ...
}: let
  colors = config.lib.stylix.colors.withHashtag;
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
    defaultOptions = [
      "--border=rounded"
      "--prompt='λ ❯ '"
      "--pointer='❯'"
      "--marker='✓'"
    ];
  };

  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$rust"
        "$golang"
        "$nodejs"
        "$python"
        "$java"
        "$kotlin"
        "$lua"
        "$nix_shell"
        "$line_break"
        "$character"
      ];

      right_format = "$cmd_duration";

      rust = {
        format = "[via](${colors.base05}) [$symbol$version](${colors.base08}) ";
        symbol = "🦀 ";
      };

      golang = {
        format = "[via](${colors.base05}) [$symbol$version](${colors.base0C}) ";
        symbol = " ";
      };

      nodejs = {
        format = "[via](${colors.base05}) [$symbol$version](${colors.base0B}) ";
        symbol = " ";
      };

      python = {
        format = "[via](${colors.base05}) [$symbol$version](${colors.base0D}) ";
        symbol = " ";
      };

      java = {
        format = "[via](${colors.base05}) [$symbol$version](${colors.base09}) ";
        symbol = " ";
      };

      kotlin = {
        format = "[via](${colors.base05}) [$symbol$version](${colors.base0E}) ";
        symbol = " ";
      };

      lua = {
        format = "[via](${colors.base05}) [$symbol$version](${colors.base0D}) ";
        symbol = " ";
      };

      character = {
        success_symbol = "[λ](${colors.base0B}) [❯](${colors.base09})";
        error_symbol = "[λ](${colors.base08}) [❯](${colors.base09})";
        vimcmd_symbol = "[λ](${colors.base0D}) [❮](${colors.base09})";
      };

      directory = {
        style = "${colors.base0D}";
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        style = "${colors.base0E}";
        format = "[on](${colors.base05}) [$branch](${colors.base0E}) ";
      };

      git_status = {
        style = "${colors.base09}";
        format = "[\\[](${colors.base04})[$all_status$ahead_behind](${colors.base09})[\\]](${colors.base04}) ";
        modified = "!";
        staged = "+";
        untracked = "?";
        deleted = "✘";
        conflicted = "═";
        ahead = "↑";
        behind = "↓";
        diverged = "⇕";
      };

      nix_shell = {
        format = "[in](${colors.base05}) [$symbol$state](${colors.base0C}) ";
        symbol = " ";
        style = "${colors.base0C}";
        impure_msg = "[impure](${colors.base09})";
        pure_msg = "[pure](${colors.base0B})";
      };

      cmd_duration = {
        style = "${colors.base04}";
        format = "[$duration]($style)";
        min_time = 2000;
      };
    };
  };

  programs.bat = {
    enable = true;
    config = {
      style = "numbers,changes,header";
    };
    extraPackages = builtins.attrValues {
      inherit
        (pkgs.bat-extras)
        batgrep
        batdiff
        ;
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      vim_keys = true;
      rounded_corners = false;
      shown_boxes = "cpu mem net proc";
      update_ms = 1000;
      proc_tree = true;
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
    package = pkgs.unstable.yazi;
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

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = ["--disable-up-arrow"];
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      search_mode = "fuzzy";
      filter_mode = "global";
      style = "compact";
      inline_height = 20;
      show_preview = true;
      enter_accept = false;
    };
  };

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

      # Terminal Aesthetic Theme
      set -g status-style "bg=${colors.base02},fg=${colors.base05}"
      set -g status-left "#[fg=${colors.base0B}]λ #[fg=${colors.base09}]❯ #[fg=${colors.base0D}]#S #[fg=${colors.base05}]│ "
      set -g status-left-length 30
      set -g status-right "#[fg=${colors.base05}]│ #[fg=${colors.base06}]%H:%M #[fg=${colors.base05}]│ #[fg=${colors.base06}]%d.%m"
      set -g status-right-length 30

      # Window status
      set -g window-status-format "#[fg=${colors.base05}][#I:#W]"
      set -g window-status-current-format "#[fg=${colors.base0B}][#I:#W]"
      set -g window-status-separator " "

      # Pane borders
      set -g pane-border-style "fg=${colors.base02}"
      set -g pane-active-border-style "fg=${colors.base0B}"

      # Message style
      set -g message-style "bg=${colors.base01},fg=${colors.base05}"

      # Mode style (copy mode)
      set -g mode-style "bg=${colors.base02},fg=${colors.base05}"
    '';

    plugins = with pkgs.tmuxPlugins; [
      {plugin = vim-tmux-navigator;}
      {plugin = sensible;}
      {plugin = tmux-fzf;}
    ];
  };
}
