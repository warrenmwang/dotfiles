{ inputs }:
let
  inherit (inputs) nixpkgs kernel-nixpkgs home-manager nur;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { 
    inherit kernel-nixpkgs;
  };
  modules = [
    { nixpkgs.overlays = [ nur.overlays.default ]; }
    ./configuration.nix
    ./hardware-configuration.nix
    ../../users/wang
    { users.users.wang.extraGroups = [ "i2c" ]; }
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        users.wang = import ../../users/wang/home-manager/hosts/nixhalla.nix;
      };
    }
  ];
}
