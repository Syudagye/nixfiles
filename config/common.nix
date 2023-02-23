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
    (writeShellScriptBin "nixos-trim-generations" (builtins.readFile (fetchurl {
      url = "https://gist.githubusercontent.com/Bondrake/27555c9d02c2882fd5e32f8ab3ed620b/raw/e1e5dd68761a7f7e6a253fcb64905466104b9df9/trim-generations.sh";
      sha256 = "0kkcxazaay71zdf7jqrsh6fpyzyji361fcfzcpdd4dmf68nj8xq3";
    }).outPath))
  ];
}
