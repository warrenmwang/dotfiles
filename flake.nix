{
  description = "NixOS config with Flakes for machines under my dominion.";

  inputs = {
    nixpkgs-nixhalla.url = "github:NixOS/nixpkgs/nixos-unstable";
    # kernel-nixhalla-nixpkgs.url = "github:NixOS/nixpkgs/08f22084e6085d19bcfb4be30d1ca76ecb96fe54";
    kernel-nixhalla-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-ironwood.url = "github:NixOS/nixpkgs/3e3afe5174c561dee0df6f2c2b2236990146329f";
    kernel-ironwood-nixpkgs.url = "github:NixOS/nixpkgs/3e3afe5174c561dee0df6f2c2b2236990146329f";
    brave-ironwood-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    tailscale-ironwood-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-gram.url = "github:NixOS/nixpkgs/nixos-unstable";
    firefox-gram-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-rock.url = "github:NixOS/nixpkgs/nixos-unstable";
    tailscale-rock-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    immich-rock-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-nixhalla = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-nixhalla";
    };
    home-manager-ironwood = {
      url = "github:nix-community/home-manager/release-25.05";
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

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    { self, ... }@inputs:
    {
      nixosConfigurations = {
        nixhalla = import ./hosts/nixhalla {
          inputs = {
            nixpkgs = inputs.nixpkgs-nixhalla;
            kernel-nixpkgs = inputs.kernel-nixhalla-nixpkgs;
            home-manager = inputs.home-manager-nixhalla;
            nur = inputs.nur-nixhalla;
          };
        };
        rock = import ./hosts/rock {
          inputs = {
            nixpkgs = inputs.nixpkgs-rock;
            tailscale-nixpkgs = inputs.tailscale-rock-nixpkgs;
            immich-nixpkgs = inputs.immich-rock-nixpkgs;
            home-manager = inputs.home-manager-rock;
            llm-agents = inputs.llm-agents;
          };
        };
        ironwood = import ./hosts/ironwood {
          inputs = {
            nixpkgs = inputs.nixpkgs-ironwood;
            kernel-nixpkgs = inputs.kernel-ironwood-nixpkgs;
            brave-nixpkgs = inputs.brave-ironwood-nixpkgs;
            tailscale-nixpkgs = inputs.tailscale-ironwood-nixpkgs;
            home-manager = inputs.home-manager-ironwood;
            nur = inputs.nur-ironwood;
          };
        };
        gram = import ./hosts/gram {
          inputs = {
            nixpkgs = inputs.nixpkgs-gram;
            firefox-nixpkgs = inputs.firefox-gram-nixpkgs;
            home-manager = inputs.home-manager-gram;
            nur = inputs.nur-gram;
          };
        };
      };
    };
}
