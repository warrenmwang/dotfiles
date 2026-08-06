{ inputs }:
let
  inherit (inputs) nixpkgs kernel-nixpkgs brave-nixpkgs tailscale-nixpkgs home-manager nur;
  system = "x86_64-linux";
  tailscalePkgs = import tailscale-nixpkgs { inherit system; };
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { 
    inherit kernel-nixpkgs brave-nixpkgs tailscalePkgs;
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
