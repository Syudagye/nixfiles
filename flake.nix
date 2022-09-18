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
    # leftwm.url = "path:leftwm";
    # leftwm.url = "path:leftwm-fix";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkUser = host: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = inputs;
        modules = [
          ./hosts/${host}/home.nix
        ];
      };

      mkSys = host: nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = inputs;
        modules = [
          # Import system generated configuration
          # impure, but leave the file untouched
          /etc/nixos/hardware-configuration.nix
          ./hosts/${host}
        ];
      };
    in
    {
      # nixosConfigurations.fancy-toaster = nixpkgs.lib.nixosSystem {
      #   inherit system;
      #   modules = [ ./hosts/fancy-toaster/configuration.nix ];
      #   specialArgs = inputs;
      # };
      nixosConfigurations = {
        fancy-toaster = mkSys "fancy-toaster";
      };

      # homeConfigurations.syu = home-manager.lib.homeManagerConfiguration {
      #   inherit pkgs;
      #   modules = [
      #     ./home.nix
      #   ];
      #   extraSpecialArgs = inputs;
      # };
      homeConfigurations = {
        fancy-toaster = mkUser "fancy-toaster";
      };
    };
}
