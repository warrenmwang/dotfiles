{ inputs }:
let
  inherit (inputs)
    nixpkgs
    nixpkgs-tailscale
    nixpkgs-immich
    home-manager
    llm-agents
    ;
  system = "x86_64-linux";
  tailscalePkgs = import nixpkgs-tailscale { inherit system; };
  immichPkgs = import nixpkgs-immich { inherit system; };
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit llm-agents tailscalePkgs immichPkgs; };
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
        backupFileExtension = "hm-backup";
        users.wang = import ../../users/wang/home-manager/hosts/rock.nix;
      };
    }
  ];
}
