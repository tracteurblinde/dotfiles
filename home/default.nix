{ nixpkgs, home-manager, utils, dotfiles-private, ... }@inputs:
let
  lib = nixpkgs.lib;
  mkHomeConfig = user: host:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import ../overlay.nix)
        ];
      };
      userModule = dotfiles-private.users.${user} { inherit pkgs; dotfiles-utils = utils; };
      hostModule = lib.optional (builtins.pathExists ./hosts/${host}.nix) ./hosts/${host}.nix;
      roleModule = lib.optional (builtins.pathExists ./roles/${dotfiles-private.hosts.${host}.role}.nix) ./roles/${dotfiles-private.hosts.${host}.role}.nix;
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        userModule.homeConfig
        dotfiles-private.homeCommon
        ./home.nix
        utils.nixpkgsMerger
      ] ++ hostModule ++ roleModule;

      # Make flake inputs available in modules.
      extraSpecialArgs = { inherit inputs; };
    };

  users = builtins.attrNames dotfiles-private.users;
  hosts = builtins.attrNames dotfiles-private.hosts;
in
rec {
  generateHomeManagerConfigs = builtins.listToAttrs (
    builtins.concatMap
      (user:
        builtins.map
          (host: {
            name = "${user}@${host}";
            value = mkHomeConfig user host;
          })
          hosts
      )
      users
  );
}
