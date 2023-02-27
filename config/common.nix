{ config, pkgs, ... } @ inputs:

{
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      dates = "weekly";
      automatic = true;
    };
    optimise = {
      dates = [ "weekly" ];
      automatic = true;
    };
  };

  # NETWORKING
  networking = {
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
    initialPassword = "";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "dialout" "wireshark" ];
  };

  # SYSTEM PACKAGES
  environment.systemPackages = with pkgs; [
    vim
    neovim # Yep both editors cuz why not
    wget
    dosfstools
    w3m
    git
    cmake
    pkg-config
    zip
    unzip
    htop
    neofetch
  ];
}
