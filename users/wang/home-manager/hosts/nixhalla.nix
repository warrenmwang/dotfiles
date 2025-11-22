{ pkgs, config, ... }:
{
  imports = [
    ../default.nix
    ../dotfiles.nix
    ../desktop.nix
    ../firefox.nix
  ];
}
