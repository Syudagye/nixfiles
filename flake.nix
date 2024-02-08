{
  description = "Syu's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05-aarch64";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # home-manager-stable = {
    #   url = "github:nix-community/home-manager/release-22.05";
    #   inputs.nixpkgs.follows = "nixpkgs-stable";
    # };
    leftwm.url = github:Syudagye/leftwm/x11rb;
    lefthk.url = github:leftwm/lefthk;
    eww.url = github:Syudagye/eww/tray-3;
    hyprland.url = github:hyprwm/hyprland;
    funky-tags.url = github:Syudagye/funky-tags;
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... } @ inputs:
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
      # Systems configs
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

      # home-manager configs
      homeConfigurations.archbtw =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
          overlays = (import ./overlays.nix) pkgs;
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            inherit overlays;
          };
          modules = [
            ./home/archbtw
          ];
          extraSpecialArgs = inputs;
        };
    };
}
