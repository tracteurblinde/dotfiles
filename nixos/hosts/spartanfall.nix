{ config, lib, pkgs, ... }:

{
  networking.hostName = "spartanfall";
  time.timeZone = "America/Los_Angeles";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # AMD Discrete and Intel Integrated Graphics
  # The order matters. This configuration seems to be the most stable.
  boot.initrd.kernelModules = [ "i915" "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" "i915" ];

  # Xbox One Controller
  hardware.xone.enable = true;

  nixpkgs.allowUnfreePackages = [
    "talon"
    "xow_dongle-firmware"
  ];

  hardware.graphics = {
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr.icd
      intel-compute-runtime
      intel-media-driver
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      amdvlk
      intel-media-driver
    ];
  };
  environment.variables.AMD_VULKAN_ICD = "RADV";

  environment.systemPackages = with pkgs; [
    # Logitech Mouse Configurator
    solaar
  ];

  services.udev.extraRules = ''
    # Open raw HID access to the logitech mouse for all users
    #KERNEL=="hidraw*", SUBSYSTEM=="hidraw", DRIVERS=="logitech-djreceiver", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", DRIVERS=="usbhid",              MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # For input-leap
  networking.firewall.allowedTCPPorts = [ 24800 ];

  # Spartanfall is connected to a UPS
  services.apcupsd.enable = true;

  # Talon Voice
  programs.talon.enable = true;

  services.openssh.enable = true;
}
