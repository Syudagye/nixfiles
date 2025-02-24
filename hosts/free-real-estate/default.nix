{
  config,
  pkgs,
  funky-tags,
  ...
}@inputs:

{
  imports = [
    ../../modules/boot.nix
    funky-tags.nixosModules.default
  ];

  # NETWORKING
  networking = {
    domain = "syu.ovh";
    hostName = "free-real-estate";
    firewall.allowedTCPPorts = [
      25565
      25575
      25564
      25574
      22222
      80
      443
      1818 # Firefox syncserver
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
      virtualHosts = {
        ${config.networking.domain} = {
          enableACME = true;
          forceSSL = true;
          root = "/www";
          locations."/" = {
            index = "index.html";
          };
        };
        ${config.services.nextcloud.hostName} = {
          forceSSL = true;
          enableACME = true;
        };
        "searx.${config.networking.domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8081";
          };
        };
        "bootleg-spa.${config.networking.domain}" = {
          # forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:25565";
          };
        };
        "crea.${config.networking.domain}" = {
          # forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:25564";
          };
        };
        "ffsync.${config.networking.domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:1818";
          };
        };
        "rad.${config.networking.domain}" = {
          forceSSL = true;
          enableACME = true;
          root = pkgs.radicle-explorer.outPath;
          locations."/" = {
            tryFiles = "$uri /index.html";
          };
        };
      };
    };

    nextcloud = {
      enable = true;
      hostName = "nextcloud.${config.networking.domain}";
      home = "/data/nextcloud";
      config.adminpassFile = "/data/nextpass";
      https = true;
      package = pkgs.nextcloud30;
    };

    searx = {
      enable = true;
      package = pkgs.searxng;
      settings = {
        server = {
          port = 8081;
          bind_address = "0.0.0.0";
          secret_key = "i like trains";
          image_proxy = true;
        };
        general.instance_name = "SearXNG - syu.ovh";
        search.safe_search = 1;
      };
    };

    funky-tags = {
      enable = true;
      data = "/data/funky-tags";
      vhost = "funkytags.${config.networking.domain}";
    };

    radicle = {
      enable = true;
      privateKeyFile = "/data/radicle/radicle";
      publicKey = "/data/radicle/radicle.pub";
      node = {
        listenPort = 8776;
        openFirewall = true;
      };
      settings = {
        node = {
          seedingPolicy.default = "block";
          listen = with config.services.radicle.node; [
            "${listenAddress}:${toString listenPort}"
          ];
        };
        web.pinned.repositories = [
          "rad:z4HqnbBJbu1WeUBLDgLDA88o9yfzT"
          "rad:z3PFZn1eGp2hp5rZmiGB3p3SDPyGJ"
          "rad:z3pCswqVyjBMcG5WNH1a77S7R2gnR"
        ];
      };
      httpd = {
        enable = true;
        nginx = {
          serverName = "seed.${config.networking.domain}";
          forceSSL = true;
          enableACME = true;
        };
      };
    };
  };

  # ACME
  security.acme = {
    acceptTerms = true;
    defaults.email = "syudagye@gmail.com";
  };

  # CONTAINERS
  # containers =
  #   let
  #     mkMCContainer = folder: mcPort: rconPort: {
  #       autoStart = true;
  #       bindMounts = {
  #         "/minecraft" = {
  #           hostPath = "/data/minecraft/${folder}";
  #           isReadOnly = false;
  #         };
  #       };
  #       forwardPorts = [
  #         {
  #           containerPort = 25565;
  #           hostPort = mcPort;
  #         }
  #         {
  #           containerPort = 25575;
  #           hostPort = rconPort;
  #         }
  #       ];
  #       extraFlags = [ "-U" ];
  #       # nixpkgs = nixpkgs-unstable;
  #
  #       config = { config, pkgs, ... }: {
  #         networking = {
  #           firewall.allowedTCPPorts = [
  #             25565
  #             25575
  #           ];
  #         };
  #
  #         services.minecraft-server = {
  #           enable = true;
  #           package = pkgs.papermc;
  #           eula = true;
  #           dataDir = "/minecraft";
  #         };
  #
  #         system.stateVersion = "22.05";
  #       };
  #     };
  #   in
  #   {
  #     bootleg-spa = mkMCContainer "bootleg-spa" 25565 25575;
  #     crea = mkMCContainer "crea" 25564 25574;
  #   };

  # Extra packages
  environment.systemPackages = with pkgs; [
    # For minecraft servers
    screen
    jdk17_headless

    # Firefox sync
    syncstorage-rs
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
