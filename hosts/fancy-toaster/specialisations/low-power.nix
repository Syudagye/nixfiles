{ lib, ... }:

{
  inheritParentConfig = true;
  configuration = {
    virtualisation.virtualbox.host.enable = lib.mkForce false;
    boot.extraModprobeConfig = ''
      # Disable ethernet interface
      blacklist r8169

      # Disables some bluetooth related things
      blacklist btusb
    '';
  };
}
