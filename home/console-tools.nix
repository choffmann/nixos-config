{pkgs, ...}:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
  };


  programs.fd.enable = true;
  programs.ripgrep.enable = true;
  programs.btop.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.jq.enable = true;

  home.packages = with pkgs; [
    yq
    openssl
    wget
  ];
}
