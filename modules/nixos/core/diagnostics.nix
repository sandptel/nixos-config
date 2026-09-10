{ pkgs, ... }:
{
  # Hardware/stack inspection tooling. Nothing here is a runtime dependency --
  # these exist so the graphics, PCI and sensor config can actually be verified.
  environment.systemPackages = with pkgs; [
    pciutils # lspci
    usbutils # lsusb
    lm_sensors # sensors
    libva-utils # vainfo  -> verifies the VA-API decode stack in graphics.nix
    vulkan-tools # vulkaninfo -> verifies RADV
    rocmPackages.rocminfo # rocminfo -> reports the real gfx arch (see graphics.nix)
  ];
}
