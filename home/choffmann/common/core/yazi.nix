{
  pkgs,
  inputs,
  ...
}:
let
  yaziPlugins = inputs.yazi-plugins;
in
{
  programs.yazi = {
    enable = true;
    package = pkgs.unstable.yazi;
    shellWrapperName = "yy";
    enableZshIntegration = true;
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "!" ];
          run = "shell \"$SHELL\" --block --confirm";
          desc = "Open shell here";
        }
        {
          on = [ "<Esc>" ];
          run = "close";
          desc = "Cancel input";
        }
        # Tabs
        {
          on = [ "t" ];
          run = "tab_create --current";
          desc = "New tab in current dir";
        }
        {
          on = [ "T" ];
          run = "tab_close 0";
          desc = "Close current tab";
        }
        {
          on = [ "1" ];
          run = "tab_switch 0";
          desc = "Switch to tab 1";
        }
        {
          on = [ "2" ];
          run = "tab_switch 1";
          desc = "Switch to tab 2";
        }
        {
          on = [ "3" ];
          run = "tab_switch 2";
          desc = "Switch to tab 3";
        }
        {
          on = [ "4" ];
          run = "tab_switch 3";
          desc = "Switch to tab 4";
        }
        # Navigation
        {
          on = [
            "g"
            "p"
          ];
          run = "cd ~/projects";
          desc = "Go to projects";
        }
        {
          on = [
            "g"
            "d"
          ];
          run = "cd ~/downloads";
          desc = "Go to Downloads";
        }
        {
          on = [
            "g"
            "c"
          ];
          run = "cd ~/.config";
          desc = "Go to .config";
        }
        {
          on = [
            "g"
            "n"
          ];
          run = "cd ~/nixos-config";
          desc = "Go to nixos-config";
        }
        # Zoxide jump
        {
          on = [ "z" ];
          run = ''shell 'result="$(zoxide query -i)" && ya emit cd "$result"' --block'';
          desc = "Zoxide jump";
        }
        # Smart filter
        {
          on = [ "f" ];
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
        # Smart enter
        {
          on = [ "l" ];
          run = "plugin smart-enter";
          desc = "Enter dir or open file";
        }
        {
          on = [ "<Enter>" ];
          run = "plugin smart-enter";
          desc = "Enter dir or open file";
        }
        # Toggle preview pane
        {
          on = [
            "b"
            "b"
          ];
          run = "plugin toggle-pane min-preview";
          desc = "Toggle preview pane";
        }
        # Git diff
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin diff";
          desc = "Diff selected file with previous version";
        }
      ];
    };
    plugins = {
      smart-enter = "${yaziPlugins}/smart-enter.yazi";
      smart-filter = "${yaziPlugins}/smart-filter.yazi";
      git = "${yaziPlugins}/git.yazi";
      diff = "${yaziPlugins}/diff.yazi";
      full-border = "${yaziPlugins}/full-border.yazi";
      toggle-pane = "${yaziPlugins}/toggle-pane.yazi";
    };
    initLua = ''
      require("full-border"):setup()
      require("git"):setup()
    '';
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        sort_sensitive = false;
        linemode = "size";
        ratio = [
          1
          3
          4
        ];
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
        image_filter = "triangle";
        image_quality = 75;
        tab_size = 2;
      };
      opener = {
        edit = [
          {
            run = "nvim \"$@\"";
            block = true;
            for = "unix";
          }
        ];
        play = [
          {
            run = "mpv \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
        open = [
          {
            run = "xdg-open \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
      };
    };
  };
}
