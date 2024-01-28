{
  description = "Tracteur's NixOS and Home Manager configurations";

  inputs = {
    ##
    # Nixpkgs
    ##
    # 🎶I'm an unstable girl in an unstable world🎶
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default-linux";

    ##
    # Tracteur's utils and secrets
    ##
    dotfiles-utils.url = "git+ssh://tracteur-lab/tracteur/dotfiles-utils";
    dotfiles-private = {
      url = "git+ssh://tracteur-lab/tracteur/dotfiles-private";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.dotfiles-utils.follows = "dotfiles-utils";
    };

    ##
    # Other utils
    ##
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    ##
    # NixOS Modules
    ##
    # Surface Patches
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Used for Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };

    ##
    # Program Flakes
    ##
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    #   inputs.systems.follows = "systems";
    # };
    # xdg-desktop-portal-hyprland = {
    #   url = "github:hyprwm/xdg-desktop-portal-hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    #   inputs.systems.follows = "systems";
    #   inputs.hyprland-protocols.follows = "hyprland/hyprland-protocols";
    #   inputs.hyprlang.follows = "hyprland/xdph/hyprlang";
    # };
  };
  outputs = inputs@{ nixos-unstable, nixpkgs-unstable, ... }:
    let
      nixos-config = import ./nixos (inputs // { nixpkgs = nixos-unstable; });
      inherit (nixos-config) generateNixOSConfigs;

      home-config = import ./home (inputs // { nixpkgs = nixpkgs-unstable; });
      inherit (home-config) generateHomeManagerConfigs;
    in
    {
      ##
      # NixOS
      ##
      # `sudo nixos-rebuild switch --flake .#<host>`
      nixosConfigurations = generateNixOSConfigs;

      ##
      # Home Manager
      ##
      # `home-manager switch --flake .#<user>@<host>`
      # Configurations get generated programmatically from
      #  dotfiles-private.users and ./home-manager/hosts
      homeConfigurations = generateHomeManagerConfigs;
    };
}
