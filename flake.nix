{
  description = "Syu's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    leftwm.url = "github:leftwm/leftwm";
    lefthk.url = "github:Syudagye/lefthk";
    eww.url = "github:elkowar/eww";
    hyprland.url = "github:hyprwm/hyprland";
    funky-tags.url = "github:Syudagye/funky-tags";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      overlays = import ./overlays.nix;
      mksys =
        {
          nixpkgs,
          inputs,
          hostname,
          username,
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            # System configuration
            {
              nixpkgs = {
                inherit overlays;
                config.allowUnfree = true;
              };
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
    {
      # Systems configs
      nixosConfigurations = {
        fancy-toaster = mksys {
          inherit nixpkgs inputs;
          hostname = "fancy-toaster";
          username = "syu";
        };
        free-real-estate = mksys {
          inherit nixpkgs inputs;
          hostname = "free-real-estate";
          username = "syu";
        };
      };

      # home-manager configs
      homeConfigurations.archbtw =
        let
          pkgs = import nixpkgs {
            inherit overlays;
            system = "x86_64-linux";
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/archbtw ];
          extraSpecialArgs = inputs;
        };

      formatter =
        let
          systems = [
            "x86_64-linux"
            "aarch64-linux"
          ];
        in
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system overlays;
            };
          in
          pkgs.nixfmt-rfc-style
        );

      overlays.default = overlays;
    };
}
