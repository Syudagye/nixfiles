{ config, pkgs, ... } @ inputs:

{
  home-manager.users.syu = (import ./home.nix) inputs;

  # NETWORKING
  networking = {
    hostName = "free-real-estate";
    firewall.allowedTCPPorts = [
      25565
      25566
      25575
      25576
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # SERVICES
  services = {
    openssh.enable = true;
  };

  # CONTAINERS
  containers = let
    mkMCContainer = folder: mcPort: rconPort: {
      autoStart = true;
      bindMounts = {
        "/minecraft" = {
          hostPath = "/home/syu/${folder}";
          isReadOnly = false;
        };
      };
      forwardPorts = [
        {
          containerPort = 25565;
          hostPort = mcPort;
        }
        {
          containerPort = 25575;
          hostPort = rconPort;
        }
      ];
      extraFlags = [ "-U" ];

      config = { config, pkgs, ... }: {
        networking = {
          firewall.allowedTCPPorts = [
            25565
            25575
          ];
        };

        services.minecraft-server = {
          enable = true;
          package = pkgs.papermc;
          eula = true;
          dataDir = "/minecraft";
        };

        system.stateVersion = "22.05";
      };
      };
  in {
    bootleg-spa = mkMCContainer "bootleg-spa" 25565 25575;
    crea = mkMCContainer "crea" 25566 25576;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
