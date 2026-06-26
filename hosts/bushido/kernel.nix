{ pkgs, ... }:
{
  # Newest kernel for Strix Point / Zen 5 and its iGPU.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Modern systemd-based initrd: faster and more robust.
  boot.initrd.systemd.enable = true;

  # Newest AMD firmware + CPU microcode for stability on new silicon.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  boot.kernelParams = [
    # Modern AMD P-State scaling for better responsiveness and battery.
    "amd_pstate=active"

    # Work around display flicker / ring timeouts by disabling PSR.
    # "amdgpu.dcdebugmask=0x10"

    # Keep IOMMU enabled; the Ryzen NPU depends on it.
  ];
}
