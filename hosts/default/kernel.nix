{ inputs, outputs, lib, config, pkgs, ... }:
{
  
  boot = {
   kernelPackages = pkgs.linuxPackages_zen; # Kernel
    #chaotic.scx.enable = true;
    consoleLogLevel = 0 ;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
      "nowatchdog"
      "modprobe.blacklist=sp5100_tco" #watchdog for AMD
      "modprobe.blacklist=iTCO_wdt" #watchdog for Intel
    ];

  # This is for OBS Virtual Cam Support
  
  # kernelModules = [ "v4l2loopback" ];
  #   extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  #   initrd = {
  #     verbose = false;
  #     availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  #     kernelModules = [ ];
  #   };
};


}