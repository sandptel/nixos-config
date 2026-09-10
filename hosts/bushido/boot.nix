{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ESP is 1G and each generation costs ~100M (kernel + initrd). Unbounded ->
  # the ESP fills and nixos-rebuild fails; nix.gc prunes the store, not /boot.
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
  ];

  # /tmp is on the btrfs root, so it otherwise persists across reboots forever.
  boot.tmp.cleanOnBoot = true;
}
