{ pkgs, ... }:
{
  # Pinned to a series, NOT linuxPackages_latest: this box stacks three things
  # that break on kernel bumps -- sched_ext (core/scheduler.nix), amdgpu on new
  # silicon, and the rtw89 workaround (wifi.nix). Pinning makes bumps a commit.
  boot.kernelPackages = pkgs.linuxPackages_7_2;

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
