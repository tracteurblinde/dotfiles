{ nixpkgs, lanzaboote, dotfiles-private, dotfiles-utils, ... }@inputs:
let
  mkOSConfig = host: nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./common.nix
      ./users.nix
      ./hosts/${host}.nix
      dotfiles-private.hardware.${host}

      lanzaboote.nixosModules.lanzaboote
      dotfiles-utils.unfreeMerger
    ];

    # Make flake inputs and dotfiles-utils available in modules.
    specialArgs = { inherit inputs dotfiles-private dotfiles-utils; };
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
