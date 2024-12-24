{ pkgs, ...}:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {};
  };

  programs.ripgrep.enable = true;
  programs.btop.enable = true;
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.jq.enable = true;
  programs.ranger.enable = true;

  programs.lf = {
    enable = true;
    settings = {
      icons = true;
    };
    # keybindings = {};
    # commands = {};
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    tmuxinator.enable = true;
    shortcut = "Space";

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
      { plugin = vim-tmux-navigator; }
      { plugin = sensible; }
      { plugin = tmux-fzf; }
      { plugin = catppuccin; }
    ];
  };

  home.packages = with pkgs; [
    yq
    openssl
    wget
  ];
}
