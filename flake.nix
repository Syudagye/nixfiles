{
  description = "Syu's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05-aarch64";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    leftwm.url = "github:Syudagye/leftwm";
    lefthk.url = "github:Syudagye/lefthk?ref=nix-flake";
    eww-systray.url = github:Syudagye/eww;
  };

  outputs = { self, nixpkgs, home-manager, home-manager-stable, flake-utils, nix-gaming, ... } @ inputs:
    let
      mksys = { nixpkgs, inputs, system, hostname, username }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            # System configuration
            {
              nixpkgs.config.allowUnfree = true;
            }
            ./hardware/${hostname}
            ./hosts
            ./hosts/${hostname}
            ./overlays.nix

            # Home configuration
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = inputs;
                users.${username} = import ./home/${hostname};
              };
            }
          ];
        };
    in
    rec {
      nixosConfigurations = {
        fancy-toaster = mksys {
          inherit nixpkgs inputs;
          system = "x86_64-linux";
          hostname = "fancy-toaster";
          username = "syu";
        };
        free-real-estate = mksys {
          inherit nixpkgs inputs;
          system = "aarch64-linux";
          hostname = "free-real-estate";
          username = "syu";
        };
      };
    };
}
