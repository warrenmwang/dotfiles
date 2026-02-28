{ inputs }:
let
  inherit (inputs) nixpkgs nixpkgs-kernel home-manager nur;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { 
    inherit nixpkgs-kernel;
  };
  modules = [
    { nixpkgs.overlays = [ nur.overlays.default ]; }
    ./configuration.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    ../../users/sun
    ../../users/wang
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        users.wang = import ../../users/wang/home-manager/hosts/ironwood.nix;
      };
    }
  ];
}
