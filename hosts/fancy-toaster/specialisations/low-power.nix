{ config, pkgs, ... }:

{
  inheritParentConfig = true;
  configuration = {
    hardware.nvidia.modesetting.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.prime = {
      offload.enable = true;

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      amdgpuBusId = "PCI:01:00:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:05:00:0";
    };
  };
}
