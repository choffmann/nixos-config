{
  pkgs,
  lib,
  config,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  home.packages = [
    pkgs.awscli2
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
      inherit (pkgs.bat-extras)
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

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
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

}
