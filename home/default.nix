{ nixpkgs, home-manager, dotfiles-private, dotfiles-utils, ... }@inputs:
let
  mkHomeConfig = user: host:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      userModule = dotfiles-private.users.${user} { inherit pkgs dotfiles-utils; };
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        userModule.homeConfig
        dotfiles-private.homeCommon
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
