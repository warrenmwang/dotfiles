{
  description = "NixOS config with Flakes for machines under my dominion.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        nixhalla = import ./hosts/nixhalla { inherit inputs; };
        ironwood = import ./hosts/ironwood { inherit inputs; };
        # nixosConfigurations.cornerstone = ./hosts/cornerstone;
      };
    };
}
