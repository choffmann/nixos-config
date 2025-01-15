{pkgs, inputs, ...}:
{
  home.packages = with pkgs; [
    inputs.neovim.packages.${pkgs.system}.default
  ];
}
