{ config, pkgs, ... }: {
  # Use the newest kernel to support Strix Point / Zen 5 and its iGPU.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Load the newest AMD firmware and CPU microcode for stability on new silicon.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Kernel parameters to improve power management and avoid amdgpu freezes.
  boot.kernelParams = [
    # Enable modern AMD P-State scaling for better responsiveness and battery.
    "amd_pstate=active"

    # Work around display flicker and ring timeouts by disabling PSR.
    # "amdgpu.dcdebugmask=0x10"

    # Keep IOMMU enabled; the Ryzen NPU depends on it.
  ];

  # Btrfs mount options for fast compression and reduced SSD wear.
  # Keep the device and fsType in hardware.nix; this only adds mount options.
  fileSystems."/".options =
    [ "compress=zstd:1" "noatime" "ssd" "discard=async" ];

  # Use zram instead of physical swap to reduce SSD writes and improve UX.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Enable Vulkan/OpenCL/VA-API stacks for efficient video decode and gaming.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # RADV (Mesa) is enabled by default; AMDVLK is deprecated upstream.
      rocmPackages.clr.icd
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };

  # Avoid conflicts with modern AMD power scaling.
  services.tlp.enable = false;

  # Use power-profiles-daemon for laptop-friendly CPU power profiles.
  services.power-profiles-daemon.enable = true;

  # AMD-focused tooling for monitoring and gaming on Wayland/Hyprland.
  environment.systemPackages = with pkgs; [
    corectrl
    lact
    nvtopPackages.amd
    gamescope
    mangohud
  ];

  # Enable CoreCtrl for GPU monitoring and profiles.
  programs.corectrl.enable = true;

  # Allow CoreCtrl to change AMD GPU power states without extra prompts.
  hardware.amdgpu.overdrive = {
    enable = true;
    ppfeaturemask = "0xffffffff";
  };

  # Force ROCm to recognize the new iGPU architecture when running LLMs.
  environment.variables = { HSA_OVERRIDE_GFX_VERSION = "11.5.0"; };
}
