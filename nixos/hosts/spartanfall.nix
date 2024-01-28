{ config, lib, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # AMD Discrete and Intel Integrated Graphics
  # The order matters. This configuration seems to be the most stable.
  boot.initrd.kernelModules = [ "i915" "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" "i915" ];

  networking.hostName = "spartanfall";

  # Xbox One Controller
  hardware.xone.enable = true;

  nixpkgs.allowUnfreePackages = [
    "xow_dongle-firmware"
  ];

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
    intel-compute-runtime
    intel-media-driver
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
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

  # Spartanfall is connected to a UPS
  services.apcupsd.enable = true;
}
