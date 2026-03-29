{ inputs }:
let
  inherit (inputs) nixpkgs home-manager llm-agents nix-openclaw;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit (inputs) llm-agents nix-openclaw; };
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
        extraSpecialArgs = { inherit nix-openclaw; };
      };
    }
  ];
}
