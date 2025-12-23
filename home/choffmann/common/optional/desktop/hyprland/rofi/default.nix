{
  pkgs,
  lib,
  config,
  ...
}: let
  colors = config.lib.stylix.colors.withHashtag;
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.monospace.name;
  rgba = color: alpha: "rgba(${c."${color}-rgb-r"}, ${c."${color}-rgb-g"}, ${c."${color}-rgb-b"}, ${alpha})";
in {
  home.file.".local/share/rofi/themes/terminal.rasi".text = ''
    * {
        bg: ${rgba "base00" "0.8"};
        bg-alt: ${rgba "base01" "0.8"};
        fg: ${colors.base05};
        fg-alt: ${colors.base04};
        accent: ${colors.base09};
        green: ${colors.base0B};
        urgent: ${colors.base08};
        border: ${colors.base02};

        font: "${font} 13";
        background-color: transparent;
        text-color: @fg;
    }

    window {
        width: 600px;
        background-color: @bg;
        border: 1px solid;
        border-color: @border;
    }

    mainbox {
        background-color: transparent;
        children: [inputbar, message, listview, mode-switcher];
    }

    inputbar {
        background-color: @bg-alt;
        padding: 8px 12px;
        children: [prompt, textbox-prompt-colon, entry];
    }

    prompt {
        background-color: transparent;
        text-color: @green;
        padding: 0;
    }

    textbox-prompt-colon {
        expand: false;
        str: " ❯ ";
        text-color: @accent;
        padding: 0;
    }

    entry {
        background-color: transparent;
        text-color: @fg;
        placeholder: "type to search...";
        placeholder-color: @fg-alt;
        padding: 0;
        cursor: text;
    }

    message {
        background-color: @bg-alt;
        padding: 6px 12px;
    }

    textbox {
        background-color: transparent;
        text-color: @fg-alt;
    }

    listview {
        background-color: transparent;
        padding: 4px 0;
        lines: 12;
        columns: 1;
        fixed-height: true;
        scrollbar: false;
    }

    element {
        background-color: transparent;
        padding: 4px 12px;
    }

    element selected {
        background-color: @bg-alt;
        text-color: @accent;
    }

    element urgent {
        text-color: @urgent;
    }

    element active {
        text-color: @green;
    }

    element-text {
        background-color: transparent;
        text-color: inherit;
        highlight: bold underline;
    }

    element-icon {
        background-color: transparent;
        size: 18px;
        margin: 0 8px 0 0;
    }

    mode-switcher {
        background-color: @bg-alt;
        padding: 0;
    }

    button {
        background-color: transparent;
        text-color: @fg-alt;
        padding: 6px 12px;
    }

    button selected {
        text-color: @accent;
        background-color: transparent;
    }
  '';

  home.packages = with pkgs; [
    rofi-calc
    rofi-emoji
    rofi-rbw
    rbw
    pinentry-curses
    wtype
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
    };
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];
    extraConfig = {
      modi = "drun,run,window,ssh,calc,emoji";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      terminal = "ghostty";
      drun-display-format = "{name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "λ";
      display-run = "$";
      display-window = "~";
      display-ssh = "@";
      display-calc = "=";
      display-emoji = ":";
      sidebar-mode = true;
      calc-command = "echo -n '{result}' | wl-copy";
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      kb-row-tab = "";
      kb-element-next = "";
      kb-element-prev = "";
      kb-mode-next = "Tab";
      kb-mode-previous = "Shift+Tab";
    };
    theme = lib.mkForce "terminal";
  };
}
