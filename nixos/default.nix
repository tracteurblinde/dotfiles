{ nixpkgs, dotfiles-private, dotfiles-utils, ... }@inputs:
let
  lib = nixpkgs.lib;
  mkOSConfig = host:
    let
      system = "x86_64-linux";
      hostModule = dotfiles-private.hardware.${host};
      platformConfig = { config, ... }: {
        nixpkgs.hostPlatform = {
          inherit system;
          gcc = lib.optionalAttrs (hostModule ? gcc) {
            inherit (hostModule.gcc) arch tune;
          };
        };
        # Needed when transitioning from a generic x86_64-linux system to a specialized one
        # nix.settings.system-features = lib.optionalAttrs (hostModule ? gcc) [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-${hostModule.gcc.arch}" ];
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./common.nix
        ./users.nix
        ./hosts/${host}.nix
        hostModule.config
        dotfiles-private.nixosCommon
        platformConfig

        inputs.talon-nix.nixosModules.talon
        inputs.lanzaboote.nixosModules.lanzaboote
        dotfiles-utils.unfreeMerger
      ];

      # Make flake inputs and dotfiles-utils available in modules.
      specialArgs = {
        inherit inputs dotfiles-private dotfiles-utils;
      };
    };

  hosts = dotfiles-utils.findNixFilesInDir ./hosts;
in
{
  generateNixOSConfigs = builtins.listToAttrs (
    builtins.map
      (host: {
        name = host;
        value = mkOSConfig host;
      })
      hosts
  );
}
