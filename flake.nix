{
  description = "Tracteur's NixOS and Home Manager configurations";

  inputs = {
    ##
    # Nixpkgs
    ##
    # 🎶I'm an unstable girl in an unstable world🎶

    # Auxolotl is brand new and not quite stable enough to be our daily driver
    #nixos-unstable.url = "github:auxolotl/nixpkgs/nixos-unstable";
    #nixpkgs-unstable.url = "github:auxolotl/nixpkgs/nixpkgs-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default-linux";

    ##
    # Tracteur's utils and secrets
    ##
    dotfiles-utils.url = "git+ssh://tracteur-lab/tracteur/dotfiles-utils";
    dotfiles-private = {
      url = "git+ssh://tracteur-lab/tracteur/dotfiles-private";
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

    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90.0";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Used for Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Talon's NixOS module
    talon-nix = {
      url = "github:nix-community/talon-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
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

  nixConfig = {
    extra-substituters = [
      "https://cache.lix.systems"
      "https://nix-community.cachix.org"
      # "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
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
