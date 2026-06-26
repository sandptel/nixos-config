{ pkgs, ... }:
{
  # Early KMS: load amdgpu in initrd for smoother boot, no early-boot flicker.
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Vulkan / OpenCL / VA-API stacks for video decode and gaming.
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

  # Allow CoreCtrl to change AMD GPU power states without extra prompts.
  programs.corectrl.enable = true;
  hardware.amdgpu.overdrive = {
    enable = true;
    ppfeaturemask = "0xffffffff";
  };

  # Force ROCm to recognize the iGPU architecture (RDNA 3.5) for LLMs.
  environment.variables = { HSA_OVERRIDE_GFX_VERSION = "11.5.0"; };

  # AMD GPU monitoring tooling.
  environment.systemPackages = with pkgs; [
    corectrl
    lact
    nvtopPackages.amd
  ];
}
