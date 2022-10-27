{
  description = "Syu's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    leftwm.url = "github:Syudagye/leftwm";
    lefthk.url = "github:Syudagye/lefthk?ref=nix-flake";
    flake-utils.url = github:gytis-ivaskevicius/flake-utils-plus;
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... } @ inputs:
    flake-utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      channelsConfig.allowUnfree = true;

      hosts = {
        fancy-toaster = {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [
            /etc/nixos/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            ./hosts/fancy-toaster
          ];
        };

        free-real-estate = {
          system = "aarch64-linux";
          specialArgs = inputs;
          modules = [
            /etc/nixos/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            ./hosts/fancy-toaster
          ];
        };
      };
    };
}
