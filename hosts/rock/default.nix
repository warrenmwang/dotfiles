{ inputs }:
let
  inherit (inputs) nixpkgs home-manager;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    ../../users/wang
    {
      users.users.wang.extraGroups = [
        "gitea"
        "rockdrive"
      ];
    }
  ];
}
