{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })

    vesktop
  ];

}
