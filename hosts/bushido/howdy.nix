{ config, pkgs, ... }:
{
  # 1. Enable Howdy and configure its main system settings
  services.howdy = {
    enable = true;
    package = pkgs.howdy;
    
    # Maps directly to Howdy's internal config.ini sections
    settings = {
      core = {
        device_path = "/dev/video2"; 
        ignore_closed_lids = true;
      };
      video = {
        dark_threshold = 90;
      };
    };
  };

  # 2. Enable IR emitter service to control hardware infrared LEDs
  services.linux-enable-ir-emitter.enable = true;

  # 3. Enable Howdy authentication for specific PAM tasks
  security.pam.services = {
    # Face unlock for terminal sudo actions
    sudo.howdy.enable = true;
    
    # Face unlock for the Hyprland screen locker
    hyprlock.howdy.enable = true; 
  };
}