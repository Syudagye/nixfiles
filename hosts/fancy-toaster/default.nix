{ config, pkgs, nix-gaming, leftwm, lefthk, eww-systray, ... }@inputs:

{
  imports = [
    ../../modules
  ];

  specialisation = (import ./specialisations) inputs;

  # custom modules
  syu.boot = {
    graphical = true;
    kernelParams = [ "atkbd.reset" ];
    extraModprobeConfig = "options tuxedo_keyboard color_left=0x00ffff brightness=100";
  };

  users.users.syu = {
    shell = pkgs.zsh;
    packages = with pkgs; [
      # for my Hyprland config
      wl-clipboard
      wpaperd
    ];
  };
  # Needed here (might fix it later)
  programs.zsh.enable = true;

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
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  # SERVICES
  services = {

    # X11 CONFIG
    xserver = {
      enable = true;
      xkb.layout = "fr";
      videoDrivers = [ "nvidia" "amdgpu" ];
      wacom.enable = true;

      xautolock = {
        enable = true;
        killtime = 10;
        killer = "/run/current-system/systemd/bin/systemctl suspend";
        nowlocker = "${pkgs.xlockmore}/bin/xlock";
      };

      displayManager.session = [
        {
          manage = "window";
          name = "leftwm";
          start = "leftwm && waitPID=$!";
        }
      ];

      # Fallback to something stable
      desktopManager.mate.enable = true;
    };

    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
      };
    };

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.naturalScrolling = true;
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
    tlp.enable = true;

    flatpak.enable = true;

    syncthing = {
      enable = true;
      user = "syu";
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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

  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    amdgpuBusId = "PCI:01:00:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:05:00:0";
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf = {
      enable = true;
      packages = with pkgs; [
        OVMFFull.fd
      ];
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
