{ config, lib, pkgs, ... }:

{
  networking.hostName = "nacrine";
  time.timeZone = "America/Los_Angeles";

  # Unfree packages
  nixpkgs.allowUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
  ];

  boot.extraModprobeConfig = "options kvm_intel nested=1";
  boot.initrd.kernelModules = [ "i915" ];
  boot.supportedFilesystems = [ "zfs" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
  };

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver
    ];
  };


  # nacrine is connected to a UPS
  services.apcupsd.enable = true;

  services.openssh.enable = true;
  services.vscode-server.enable = true; #VSCode WA

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  # Docker
  virtualisation.docker = {
    enableNvidia = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  # Adds all users in the wheel group to the docker group
  users.extraGroups.docker.members = config.nix.settings.trusted-users;
}
