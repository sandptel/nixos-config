{ pkgs, ... }:
{
  # Mainline. Strix Point iGPU + sched_ext (core/scheduler.nix) both want new.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Modern systemd-based initrd: faster and more robust.
  boot.initrd.systemd.enable = true;

  # Newest AMD firmware + CPU microcode for stability on new silicon.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  boot.kernelParams = [
    # Modern AMD P-State scaling for better responsiveness and battery.
    "amd_pstate=active"
  ];
}
