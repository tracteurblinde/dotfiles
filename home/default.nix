{ nixpkgs, home-manager, dotfiles-private, dotfiles-utils, ... }@inputs:
let
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };

  mkHomeConfig = user: host:
    let
      user_module = dotfiles-private.users.${user} { inherit pkgs dotfiles-utils; };
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        user_module.homeConfig
        ./hosts/${host}.nix
        ./home.nix
        dotfiles-utils.unfreeMerger
      ];

      # Make flake inputs and dotfiles-utils available in modules.
      extraSpecialArgs = { inherit inputs dotfiles-utils; };
    };

  users = builtins.attrNames dotfiles-private.users;
  hosts = dotfiles-utils.findNixFilesInDir ./hosts;
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
