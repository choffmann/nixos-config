{
  pkgs,
  lib,
  ...
}: let
  tpp_ngrok = pkgs.writeShellScriptBin "tpp_ngrok" (builtins.readFile ./scripts/tpp_ngrok.sh);
  tpp_ssh_startup = pkgs.writeShellScriptBin "tpp_ssh_startup" (builtins.readFile ./scripts/tpp_ssh_startup.sh);
in {
  # TODO: move to own module

  home.packages = with pkgs; [
    tmux
    yq-go
    ngrok
    # xclip
    wl-clipboard
    manix
  ];

  programs.zsh = {
    shellAliases.tpp = "${lib.getBin tpp_ngrok}/bin/tpp_ngrok";
    shellAliases.tpp-kill = "pkill ngrok";
    shellAliases.mx = ''
      manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --preview="manix '{}'" | xargs manix
    '';
    initContent = "source ${lib.getBin tpp_ssh_startup}/bin/tpp_ssh_startup";
  };
}
