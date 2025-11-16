Dotfiles and NixOS Config

Build and switch for a specific host, using `nixhalla` as example:
```shell
sudo nixos-rebuild build --flake .#nixhalla
sudo nixos-rebuild switch --flake .#nixhalla
```