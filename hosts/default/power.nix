{ inputs, outputs, lib, config, pkgs, ... }:
{
  ## POWER
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil"; # no available for my laptop --> tlp logs 
  };
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
	  battery = {
	     governor = "powersave";
	     turbo = "auto";
         energy_performance_preference = "power";
	  };
	  charger = {
	     governor = "performance";
	     turbo = "auto";
       energy_performance_preference = "performance";
	  };
	};

  ### KERNEL
  boot.kernelParams = [
    "ahci.mobile_lpm_policy=3"
    "rtc_cmos.use_acpi_alarm=1"
  ];

  ### HWP
  systemd.tmpfiles.rules = [
    "w /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference - - - - balance_power"
  ];

  ### TLP --> https://linrunner.de/tlp/settings/processor.html#cpu-hwp-dyn-boost-on-ac-bat
  # services.tlp = {
  #     enable = true;
  #     settings = {
  #       CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #       CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

  #       CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
  #       CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

  #       # PLATFORM_PROFILE_ON_AC = "performance";
  #       # PLATFORM_PROFILE_ON_BAT = "low-power";

  #       CPU_BOOST_ON_AC=1;
  #       CPU_BOOST_ON_BAT=0;

  #       CPU_HWP_DYN_BOOST_ON_AC=1;
  #       CPU_HWP_DYN_BOOST_ON_BAT=0;


  #       CPU_MIN_PERF_ON_AC = 0;
  #       CPU_MAX_PERF_ON_AC = 100;
  #       CPU_MIN_PERF_ON_BAT = 0;
  #       CPU_MAX_PERF_ON_BAT = 60;

  #      #Optional helps save long term battery health
  #      START_CHARGE_THRESH_BAT0 = 80; # 70 and below it starts to charge
  #      STOP_CHARGE_THRESH_BAT0 = 90; # 90 and above it stops charging

  #     };
  # };

  ### SYSTEM 76 SCHEDULER
  services.system76-scheduler = {
        enable = true;
        settings.cfsProfiles = {
            enable = true;
        };
        };  
  ### POWERTOP
  powerManagement.powertop.enable = true;

services.irqbalance = {
    enable = true;
    # extraArgs = ["--policyscript=${pkgs.irqbalance}/etc/irqbalance.policy"];
    };  

  ### ThermalD
  services.thermald.enable = true;
}