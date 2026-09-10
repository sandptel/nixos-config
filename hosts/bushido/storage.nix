{ ... }:
let
  # compress/ssd/discard are btrfs superblock-wide (first mount wins) -> but
  # noatime is per-mount VFS, so every subvol needs it or it silently relatimes.
  btrfsOpts = [ "compress=zstd:1" "noatime" "ssd" "discard=async" ];
in
{
  # Device + fsType live in hardware.nix; this only adds mount options.
  fileSystems."/".options = btrfsOpts;
  fileSystems."/home".options = btrfsOpts;
  fileSystems."/nix".options = btrfsOpts;

  # Weekly fstrim to optimize the NVMe flash translation layer.
  services.fstrim.enable = true;

  # Monthly btrfs scrub for bitrot detection.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };
}
