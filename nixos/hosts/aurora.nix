{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
  ];

  microsoft-surface.surface-control.enable = true;
  microsoft-surface.kernelVersion = "6.8.9";

  networking.hostName = "aurora";

  # Unfree packages
  nixpkgs.allowUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
  ];

  boot.initrd.kernelModules = [ "i915" ];
  hardware.nvidia = {
    modesetting.enable = false;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Heterogeneous graphics configuration
    prime = {
      # Offload mode. Run an application on the discrete GPU only when requested.
      #   Use `nvidia-offload cmd` to run a command with the discrete GPU.
      #offload.enable = true;
      #offload.enableOffloadCmd = true;

      # Sync mode. Run an application on the discrete GPU and display on the integrated GPU.
      #  Uses significantly more power than offload mode.
      #sync.enable = true;

      # Reverse PRIME mode. TBH, we haven't found a good description for what this does,
      #   but everywhere calls this "highly anticipated" so it must be good, right?
      reverseSync.enable = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:243:0:0"; # F3:00.0
    };
  };

  services.xserver = {
    # Tell Xorg to use the nvidia driver
    videoDrivers = [ "nvidia" ];

    # Wacom
    wacom.enable = true;
    modules = [ pkgs.xf86_input_wacom ];
  };

  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
  ];

  programs.light.enable = true; # backlight

  hardware.bluetooth.enable = true;

  services.iptsd.enable = true;
  services.udev.packages = with pkgs; [ libwacom-surface ];
  environment.systemPackages = with pkgs; [ libwacom-surface ];
}
