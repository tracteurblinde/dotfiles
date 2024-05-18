{ nixpkgs, dotfiles-private, dotfiles-utils, ... }@inputs:
let
  lib = nixpkgs.lib;
  mkOSConfig = host:
    let
      system = "x86_64-linux";
      privateHostModule = dotfiles-private.hosts.${host};
      platformConfig = { config, ... }: {
        nixpkgs.hostPlatform = {
          inherit system;
          gcc = lib.optionalAttrs (privateHostModule ? gcc) {
            inherit (privateHostModule.gcc) arch tune;
          };
        };
        # Needed when transitioning from a generic x86_64-linux system to a specialized one
        # nix.settings.system-features = lib.optionalAttrs (privateHostModule ? gcc) [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-${privateHostModule.gcc.arch}" ];
      };
      publicHostModule = lib.optional (builtins.pathExists ./hosts/${host}.nix) ./hosts/${host}.nix;
      roleModule = lib.optional (builtins.pathExists ./roles/${privateHostModule.role}.nix) ./roles/${privateHostModule.role}.nix;
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./common.nix
        (import ./users.nix { inherit host; })
        privateHostModule.config
        dotfiles-private.nixosCommon
        platformConfig

        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.lix-module.nixosModules.default
        inputs.talon-nix.nixosModules.talon

        dotfiles-utils.unfreeMerger
      ] ++ publicHostModule ++ roleModule;

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
