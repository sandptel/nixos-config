{ pkgs, ... }:
{
  # Early KMS: load amdgpu in initrd for smoother boot, no early-boot flicker.
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Vulkan / OpenCL / VA-API stacks for video decode and gaming.
  # Verify with `vulkaninfo` / `vainfo` (core/diagnostics.nix).
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # RADV (Mesa) is enabled by default; AMDVLK is deprecated upstream.
      rocmPackages.clr.icd
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };

  # CoreCtrl owns AMD GPU power states (ships the polkit rules). Do not also
  # enable services.lact -- two control daemons fighting over the same sysfs.
  programs.corectrl.enable = true;

  # NOT set: hardware.amdgpu.overdrive / ppfeaturemask = "0xffffffff".
  # Buys ~nothing on an iGPU sharing the CPU power budget, and is a known source
  # of ring timeouts / GPU hangs. https://wiki.archlinux.org/title/AMDGPU#Overclocking
  #
  # NOT set: HSA_OVERRIDE_GFX_VERSION. This GPU is gfx1150 (pci 1002:150E) and
  # "11.5.0" just re-declares the native arch, globally, for every process.
  # Confirm with `rocminfo | grep gfx`; if a HIP app still needs it, export
  # HSA_OVERRIDE_GFX_VERSION=11.0.0 in that app's shell, not system-wide.

  environment.systemPackages = with pkgs; [
    corectrl
    nvtopPackages.amd
  ];
}
