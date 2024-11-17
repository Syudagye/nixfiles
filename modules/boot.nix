# Boot configuration, UEFI only for now
{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.syu.boot;
in
{
  options.syu.boot = {
    graphical = mkOption {
      type = types.bool;
      default = false;
    };
    efiSysMountPoint = mkOption {
      type = types.str;
      default = "/efi";
    };
    kernelParams = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    extraModprobeConfig = mkOption {
      type = types.str;
      default = "";
    };
  };

  config.boot =
    let
      theme =
        (fetchTarball {
          url = "https://github.com/alealexpro100/various_files/raw/master/Grub2-theme%20CyberRe%201.0.0.tar.gz";
          name = "grub-CyberRe";
          sha256 = "1g227qqlysixgggwmzjblq2xn3wa0729djaqji1rnjd3llg10qa5";
        })
        + "/CyberRe";
      extraEntries = ''
        menuentry 'UEFI Firmware Settings' --id 'uefi-firmware' {
        	fwsetup
        }

        menuentry "System shutdown" {
        	echo "System shutting down..."
        	halt
        }
      '';
    in
    {
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = cfg.graphical;
          theme = mkIf cfg.graphical theme;
          extraEntries = mkIf cfg.graphical extraEntries;
        };
        efi = {
          inherit (cfg) efiSysMountPoint;
          canTouchEfiVariables = true;
        };
      };
      tmp.useTmpfs = true;
      inherit (cfg) kernelParams extraModprobeConfig;
    };
}
