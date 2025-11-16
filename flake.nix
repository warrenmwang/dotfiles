{
  description = "NixOS config with Flakes for machines under my dominion.";

  inputs = {
    nixpkgs-nixhalla.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-ironwood.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-cornerstone.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-nixhalla = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-nixhalla";
    };
    home-manager-ironwood = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-ironwood";
    };
    # home-manager-cornerstone = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs-cornerstone";
    # };

    nur-nixhalla = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-nixhalla";
    };
    nur-ironwood = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-ironwood";
    };
    # nur-cornerstone = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs-cornerstone";
    # };

  };

  outputs =
    { self, ...  }@inputs:
    {
      nixosConfigurations = {
        nixhalla = import ./hosts/nixhalla {
          inputs = {
            nixpkgs = inputs.nixpkgs-nixhalla;
            home-manager = inputs.home-manager-nixhalla;
            nur = inputs.nur-nixhalla;
          };
        };
        ironwood = import ./hosts/ironwood {
          inputs = {
            nixpkgs = inputs.nixpkgs-ironwood;
            home-manager = inputs.home-manager-ironwood;
            nur = inputs.nur-ironwood;
          };
        };
        # nixosConfigurations.cornerstone = ./hosts/cornerstone;
      };
    };
}
