{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # general thermal management
  services.thermald.enable = true;
  services.irqbalance = {
    enable = true;
    # extraArgs = ["--policyscript=${pkgs.irqbalance}/etc/irqbalance.policy"];
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # Kernel
    #chaotic.scx.enable = true;
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" # this is to mask that stupid 1.5 mins systemd bug
      "nowatchdog"
      #Intel GPU DRIVERS
      "modprobe.blacklist=iTCO_wdt" # watchdog for Intel
      "i915.enable_psr=1" # Enables Panel Self Refresh (power saving)
      "i915.enable_fbc=1" # Enables Frame Buffer Compression
      "i915.enable_guc=2" # Enables GuC firmware for better scheduling
      "i915.fastboot=1" # Reduces boot flicker

      "intel_pstate=active"

      # Better for battery Life
      "pcie_aspm=force" # Enable ASPM (Active State Power Management)
    ];

    # This is for OBS Virtual Cam Support

    #   kernelModules = [ "v4l2loopback" ];
    #     extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

    #   initrd = {
    #     verbose = false;
    #     availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    #     kernelModules = [ ];
    #   };
  };

}
