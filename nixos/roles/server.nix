{ config, inputs, lib, pkgs, nixpkgs, ... }:

{
  # Bootloader.
  boot = {
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = lib.mkForce false;
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    htop
    busybox
  ];
}
