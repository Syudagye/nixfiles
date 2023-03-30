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
    flake-utils.url = github:gytis-ivaskevicius/flake-utils-plus;
    eww-systray.url = github:Syudagye/eww;
  };

  outputs = { self, nixpkgs, home-manager, home-manager-stable, flake-utils, nix-gaming, ... } @ inputs:
    let
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      clickgen = pkgs.callPackage ./pkgs/clickgen.nix {
        inherit (pkgs.python3Packages) buildPythonPackage pythonOlder pytestCheckHook pillow python toml numpy attrs;
        inherit (pkgs.xorg) libXcursor libX11;
      };
      breezex-cursor = pkgs.callPackage ./pkgs/breezex-cursor {
        inherit clickgen;
      };
      overlays = [
        (self: super: {
          inherit breezex-cursor;
        })
      ];
    in
    flake-utils.lib.mkFlake rec {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      channelsConfig.allowUnfree = true;
      sharedOverlays = overlays;

      hostDefaults = {
        modules = [
          ./config/common.nix

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = inputs;
            };
            nixpkgs.overlays = overlays;
          }
        ];
        extraArgs = inputs;
      };

      hosts = {
        fancy-toaster = {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.users.syu = import ./hosts/fancy-toaster/home.nix;
            }
            ./hosts/fancy-toaster/hardware-configuration.nix
            ./hosts/fancy-toaster
          ];
        };

        free-real-estate = {
          system = "aarch64-linux";
          # channelName = "nixpkgs-stable";
          extraArgs = { nixpkgs-unstable = nixpkgs; };
          modules = [
            home-manager-stable.nixosModules.home-manager
            {
              home-manager.users.syu = import ./hosts/free-real-estate/home.nix;
            }
            ./hosts/free-real-estate/hardware-configuration.nix
            ./hosts/free-real-estate
          ];
        };
      };

      homeConfigurations.archbtw = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit overlays; system = "x86_64-linux"; };
        modules = [
          ./hosts/archbtw/home.nix
        ];
        extraSpecialArgs = inputs;
      };
    };
}
