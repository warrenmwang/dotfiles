{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.username = "wang";
  home.homeDirectory = "/home/wang";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
