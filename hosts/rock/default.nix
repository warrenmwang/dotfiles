{ inputs }:
let
  inherit (inputs) nixpkgs home-manager;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../../users/wang
    {
      users.users.wang.extraGroups = [
        "gitea"
        "rockdrive"
      ];
    }
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        users.wang = import ../../users/wang/home-manager/hosts/rock.nix;
      };
    }
  ];
}
