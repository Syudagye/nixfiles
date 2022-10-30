{
  description = "Syu's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    leftwm.url = "github:Syudagye/leftwm";
    lefthk.url = "github:Syudagye/lefthk?ref=nix-flake";
    flake-utils.url = github:gytis-ivaskevicius/flake-utils-plus;
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, flake-utils, ... } @ inputs:
    flake-utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      channelsConfig.allowUnfree = true;

      hostDefaults.modules = [
        ./modules/boot.nix

        ./config/common.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # home-manager.users.jdoe = import ./home.nix;
        }
      ];

      hosts = {
        fancy-toaster = {
          system = "x86_64-linux";
          channelName = "nixpkgs";
          specialArgs = inputs;
          modules = [
            /etc/nixos/hardware-configuration.nix
            ./hosts/fancy-toaster
          ];
        };

        free-real-estate = {
          system = "aarch64-linux";
          channelName = "nixpkgs-stable";
          specialArgs = inputs;
          modules = [
            /etc/nixos/hardware-configuration.nix
            ./hosts/free-real-estate
          ];
        };
      };
    };
}
