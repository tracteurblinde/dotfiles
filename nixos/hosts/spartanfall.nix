{ config, lib, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # AMD Drivers
  boot.initrd.kernelModules = [ "i915" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  networking.hostName = "spartanfall";

  nixpkgs.allowUnfreePackages = [ ];

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
    intel-compute-runtime
    intel-media-driver
  ];
  environment.variables.AMD_VULKAN_ICD = "RADV";

  environment.systemPackages = with pkgs; [
    # Logitech Mouse Configurator
    solaar
  ];

  # Open raw HID access to the logitech mouse for all users
  #  services.udev.extraRules = ''
  #KERNEL=="hidraw*", SUBSYSTEM=="hidraw", DRIVERS=="logitech-djreceiver", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  #'';
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # For input-leap
  networking.firewall.allowedTCPPorts = [ 24800 ];
}
