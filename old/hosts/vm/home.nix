{ pkgs, ... }:
{
  imports = [ ../../home ];

  programs.git = {
    enable = true;
    userName = "Cedrik Hoffmann";
    userEmail = "cedrik.hoffmann@jgdperl.com";
  };
}
