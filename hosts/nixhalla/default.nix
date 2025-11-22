{ inputs }:
let
  inherit (inputs) nixpkgs home-manager nur;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    { nixpkgs.overlays = [ nur.overlays.default ]; }
    ./configuration.nix
    ./hardware-configuration.nix
    ../../users/wang
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        users.wang = import ../../users/wang/home-manager/hosts/nixhalla.nix;
      };
    }
  ];
}
