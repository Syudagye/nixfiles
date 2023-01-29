{ config, pkgs, nix-gaming, leftwm, lefthk, eww-systray, ... }:

{
  imports = [
    ../../modules
  ];

  nix = {
    settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };
  };

  # custom modules
  syu.boot = {
    graphical = true;
    kernelParams = [ "atkbd.reset" ];
    extraModprobeConfig = "options tuxedo_keyboard color_left=0x00ffff brightness=100";
  };

  networking.hostName = "fancy-toaster";

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
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

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
      # modules = with pkgs; [
      #   xf86_input_wacom
      # ];
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
    # udev.extraRules = ''
    #   ACTION==\"add\", SUBSYSTEM==\"backlight\", KERNEL==\"amdgpu_bl1\", GROUP=\"video\", MODE=\"0664\", RUN+=\"${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness\"
    # '';
    udisks2.enable = true;

    # for thunar
    gvfs.enable = true;
    tumbler.enable = true;

    # setup for mysql
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    # Battery saving
    tlp = {
      enable = true;
      # settings = {
      #   SOUND_POWER_SAVE_ON_AC = 0;
      #   SOUND_POWER_SAVE_ON_BAT = 1;
      #   SOUND_POWER_SAVE_CONTROLLER = "N";
      #   PLATFORM_PROFILE_ON_AC = "performance";
      #   PLATFORM_PROFILE_ON_BAT = "low-power";
      #   CPU_SCALING_GOVERNOR_ON_AC = "performance";
      #   CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      # };
    };
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

  virtualisation.virtualbox.host.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
