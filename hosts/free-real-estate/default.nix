{ config, pkgs, ... } @ inputs:

{
  home-manager.users.syu = (import ./home.nix) inputs;

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      dates = "weekly";
      automatic = true;
    };
  };

  # BOOTLOADER
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };

  # NETWORKING
  networking = {
    hostName = "free-real-estate";
    networkmanager.enable = true;
    firewall.allowPing = true;
  };

  # TIMEZONE
  time.timeZone = "Europe/Paris";

  # CONSOLE
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr-latin1";

  # USERS
  users.users.syu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # SYSTEM PACKAGES
  environment.systemPackages = with pkgs; [
    vim
    wget
    dosfstools
    w3m
    git
    cmake
    pkg-config
  ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # NIXPKGS CONFIG
  # nixpkgs.config = {
  #   allowUnfree = true;
  # };

  # SERVICES
  services = {
    openssh.enable = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

