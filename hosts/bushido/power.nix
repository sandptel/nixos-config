{ ... }:
{
  # Use power-profiles-daemon for laptop CPU power profiles.
  # Disable TLP to avoid conflicts with modern AMD power scaling.
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = true;

  # zram instead of physical swap: reduces SSD writes, improves UX.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # zram tuning: with compressed RAM swap, swap aggressively and don't
  # read-ahead swap pages (kernel-doc recommendation for zram setups).
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
  };
}
