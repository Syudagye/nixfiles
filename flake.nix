{
  description = "Syu's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    leftwm.url = "github:Syudagye/leftwm";
    lefthk.url = "github:Syudagye/lefthk?ref=nix-flake";
    flake-utils.url = github:gytis-ivaskevicius/flake-utils-plus;
  };

  outputs = { self, nixpkgs, home-manager, home-manager-stable, flake-utils, nix-gaming, ... } @ inputs:
    let
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      clickgen = import ./pkgs/clickgen.nix {
        inherit (pkgs) lib stdenv fetchFromGitHub libpng;
        inherit (pkgs.python3Packages) buildPythonPackage pythonOlder pytestCheckHook pillow python toml numpy attrs;
        inherit (pkgs.xorg) libXcursor libX11;
      };
      breezex-cursor = import ./pkgs/breezex-cursor {
        inherit clickgen;
        inherit (pkgs) lib stdenv fetchFromGitHub mkYarnPackage;
      };
    in
    flake-utils.lib.mkFlake rec {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      channelsConfig.allowUnfree = true;

      hostDefaults = {
        modules = [
          ./modules/boot.nix

          ./config/common.nix

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
        extraArgs = inputs;
      };

      hosts = {
        fancy-toaster = {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/fancy-toaster/hardware-configuration.nix
            ./hosts/fancy-toaster
          ];
        };

        free-real-estate = {
          system = "aarch64-linux";
          channelName = "nixpkgs-stable";
          extraArgs = { nixpkgs-unstable = nixpkgs; };
          modules = [
            home-manager-stable.nixosModules.home-manager
            /etc/nixos/hardware-configuration.nix
            ./hosts/free-real-estate
          ];
        };
      };

      homeConfigurations.archbtw = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./hosts/archbtw/home.nix
        ];
        extraSpecialArgs = inputs // { inherit breezex-cursor; };
      };

      outputBuilder = channels: {
        packages = rec { };
      };
    };
}
