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
  ];

  programs.zsh = {
    shellAliases.tpp = "${lib.getBin tpp_ngrok}/bin/tpp_ngrok";
    shellAliases.tpp-kill = "pkill ngrok";
    initExtra = "source ${lib.getBin tpp_ssh_startup}/bin/tpp_ssh_startup";
  };
}
