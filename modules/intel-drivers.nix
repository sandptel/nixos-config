{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.drivers.intel;
in
{
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
    # https://github.com/intel/compute-runtime
    # 
    # OpenGL/OpenCL --> Added Intel Runtime Compute (Xe graphics) support
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime # https://nixos.org/manual/nixos/unstable/#sec-gpu-accel-opencl-intel
        intel-ocl
        ocl-icd
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
        libva
			  libva-utils	
      ];
    };

    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
    boot.initrd.kernelModules = [ "i915" ];
    services.xserver.videoDrivers = [
    "i915"
    "modesetting"
    # "intel"
    ];

    # All these mean the same thing defined above as hardware.graphics is the new hardawre.opengl
    # https://discourse.nixos.org/t/laptop-performance-on-nixos/42259/2
    #https://discourse.nixos.org/t/video-acceleration-not-working-in-intel-iris-xe-graphic-13th-gen-i51340p/33367/2
    # hardware.opengl.enable = true;
    # # hardware.opengl.driSupport = true; #seems to be removed
    # hardware.opengl.driSupport32Bit = true;
    # hardware.opengl.extraPackages = with pkgs; [
    #     intel-media-driver
    #     vaapiVdpau
    #     libvdpau-va-gl
    #   ];
    #https://nixos.wiki/wiki/Accelerated_Video_Playback
    

  };
}
