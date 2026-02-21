{
  description = "NixOS config with Flakes for machines under my dominion.";

  inputs = {
    nixpkgs-nixhalla.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-nixhalla-kernel.url = "github:NixOS/nixpkgs/08f22084e6085d19bcfb4be30d1ca76ecb96fe54";
    nixpkgs-nixhalla-kernel.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-ironwood.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-gram.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-rock.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-nixhalla = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-nixhalla";
    };
    home-manager-ironwood = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-ironwood";
    };
    home-manager-gram = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-gram";
    };
    home-manager-rock = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-rock";
    };

    nur-nixhalla = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-nixhalla";
    };
    nur-ironwood = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-ironwood";
    };
    nur-gram = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-gram";
    };
  };

  outputs =
    { self, ... }@inputs:
    {
      nixosConfigurations = {
        nixhalla = import ./hosts/nixhalla {
          inputs = {
            nixpkgs = inputs.nixpkgs-nixhalla;
            nixpkgs-kernel = inputs.nixpkgs-nixhalla-kernel;
            home-manager = inputs.home-manager-nixhalla;
            nur = inputs.nur-nixhalla;
          };
        };
        rock = import ./hosts/rock {
          inputs = {
            nixpkgs = inputs.nixpkgs-rock;
            home-manager = inputs.home-manager-rock;
          };
        };
        ironwood = import ./hosts/ironwood {
          inputs = {
            nixpkgs = inputs.nixpkgs-ironwood;
            home-manager = inputs.home-manager-ironwood;
            nur = inputs.nur-ironwood;
          };
        };
        gram = import ./hosts/gram {
          inputs = {
            nixpkgs = inputs.nixpkgs-gram;
            home-manager = inputs.home-manager-gram;
            nur = inputs.nur-gram;
          };
        };
      };
    };
}
