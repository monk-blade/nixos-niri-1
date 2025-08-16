{ config, lib, pkgs, ... }:

{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    
    # Additional OpenGL packages
    extraPackages = with pkgs; [
      intel-media-driver # For Intel graphics (VAAPI)
      vaapiIntel         # For Intel graphics (VAAPI)
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # For Intel OpenCL
    ];
  };

  # Graphics drivers
  services.xserver.videoDrivers = [ "intel" "amdgpu" "radeon" "nouveau" "modesetting" ];
  
  # Enable hardware acceleration
  hardware.enableRedistributableFirmware = true;
  
  # For AMD graphics
  hardware.amdgpu.opencl.enable = true;
  
  # Vulkan support
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  
  # For 32-bit Vulkan support on 64-bit systems
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [
    amdvlk
  ];
  
  # Enable VA-API hardware acceleration
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # For Intel graphics
  };
}
