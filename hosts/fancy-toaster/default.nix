{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # BOOTLOADER
  boot = {
    kernelParams = [ "atkbd.reset" ];
    extraModprobeConfig = "options tuxedo_keyboard color_left=0x00ffff brightness=100";
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        theme = "/home/syu/CyberRe 1.0.0/CyberRe/";
        extraEntries =
          ''
            menuentry 'UEFI Firmware Settings' --id 'uefi-firmware' {
            	fwsetup
            }

            menuentry "System shutdown" {
            	echo "System shutting down..."
            	halt
            }
          '';
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };

  # NETWORKING
  networking = {
    hostName = "fancy-toaster";
    networkmanager.enable = true;
  };

  # TIMEZONE
  time.timeZone = "Europe/Paris";

  # CONSOLE
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr-latin1";

  # USERS
  users.users.syu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
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
  ];
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
  };

  # NIXPKGS CONFIG
  # nixpkgs.config = {
  #   allowUnfree = true;
  # };

  # FONTS
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      iosevka-bin
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Iosevka" ];
    };
  };

  # SERVICES
  services = {

    # X11 CONFIG
    xserver = {
      enable = true;
      layout = "fr";
      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
        touchpad.naturalScrolling = true;
      };
      modules = with pkgs; [
        xf86_input_wacom
      ];
      videoDrivers = [ "nvidia" "amdgpu" ];
      wacom.enable = true;

      windowManager.i3.enable = true;

      displayManager = {
        lightdm = {
          enable = true;
          greeters.gtk.enable = true;
          extraConfig = "logind-check-graphical=true";
        };
        session = [
          {
            manage = "window";
            name = "leftwm";
            start = "leftwm && waitPID=$!";
          }
          {
            manage = "window";
            name = "river";
            start = "river && waitPID=$!";
          }
          # {
          #   manage = "desktop";
          #   name = "LeftWM";
          #   start = "exec $HOME/.xsession";
          # }
        ];
      };
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    # PIPEWIRE
    pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };

    # Others
    openssh.enable = true;
    upower.enable = true;
    udev.extraRules = ''
      ACTION==\"add\", SUBSYSTEM==\"backlight\", KERNEL==\"amdgpu_bl1\", GROUP=\"video\", MODE=\"0664\", RUN+=\"${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness\"
    '';
    udisks2.enable = true;

    # for thunar
    gvfs.enable = true;
    tumbler.enable = true;
  };
  # Enable sound.
  sound.enable = true;
  # Enable OpenGL for 32-bit
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia.modesetting.enable = true;
    tuxedo-keyboard.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
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

