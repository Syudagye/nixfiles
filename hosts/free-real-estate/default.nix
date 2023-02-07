{ config, pkgs, nixpkgs-unstable, ... } @ inputs:

{
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMointPoint = "/efi";
    };
  };

  # NETWORKING
  networking = {
    hostName = "free-real-estate";
    firewall.allowedTCPPorts = [
      25565
      25566
      25575
      25576
      22222
      80
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # SERVICES
  services = {
    openssh.enable = true;
    mysql.enable = true;
    mysql.package = pkgs.mariadb;

    nginx = {
      enable = true;
      virtualHosts.home-page = {
        #default = true;
        root = "/www";
        locations."/" = {
          index = "index.html";
          #tryFiles = "$uri =404";
        };
      };
    };
  };

  # CONTAINERS
  containers =
    let
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
        nixpkgs = nixpkgs-unstable;

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
      redbotInstance = "muzik_trouville";
    in
    {
      bootleg-spa = mkMCContainer "bootleg-spa" 25565 25575;
      crea = mkMCContainer "crea" 25564 25574;
      redbot = {
        autoStart = true;
        config = { config, pkgs, ... }: {
          system.stateVersion = "22.05";
          users.users.redbot = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
          };
          # SYSTEM PACKAGES
          environment = {
            systemPackages = with pkgs; [
              neovim
              (pkgs.python39.withPackages (p: [ p.pip ]))
              jdk11_headless
              gcc
              gnumake
              screen
              (pkgs.writeShellScriptBin "setup-bot" ''
                python3.9 -m venv ~/
                source ~/bin/activate
                python -m pip install -U pip setuptools wheel
                python -m pip install -U Red-DiscordBot
                redbot-setup --instance-name "${redbotInstance}"
                redbot "${redbotInstance}"
              '')
            ];
            variables.REDBOT_INSTANCE_NAME = "muzik_trouville";
          };
          # Redbot service
          systemd.services.redbot = {
            description = "Redbot service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            path = [ pkgs.jdk11_headless ];
            serviceConfig = {
              ExecStart = "/home/redbot/bin/python -O -m redbot ${redbotInstance} --no-prompt";
              Type = "idle";
              User = "redbot";
            };
          };
        };
      };
    };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
