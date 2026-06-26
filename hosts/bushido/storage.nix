{ ... }:
{
  # Btrfs mount options for fast compression and reduced SSD wear.
  # Device and fsType live in hardware.nix; this only adds mount options.
  fileSystems."/".options =
    [ "compress=zstd:1" "noatime" "ssd" "discard=async" ];

  # Weekly fstrim to optimize the NVMe flash translation layer.
  services.fstrim.enable = true;

  # Monthly btrfs scrub for bitrot detection.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };
}
