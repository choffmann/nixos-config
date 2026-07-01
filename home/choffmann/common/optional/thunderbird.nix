{ pkgs, ... }: {
  home.packages = with pkgs; [
    thunderbird
  ];

  # accounts.email.accounts."<name>" = {};
  # programs.thunderbird = {
  #   enable = true;
  # };
}
