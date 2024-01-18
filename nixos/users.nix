{ config, pkgs, lib, dotfiles-private, dotfiles-utils, ... }@inputs:
let
  generateNixOSUserAccounts = builtins.listToAttrs (
    builtins.map
      (user:
        let
          user_module = dotfiles-private.users.${user} { inherit pkgs dotfiles-utils; };
        in
        {
          name = user;
          value = user_module.nixosConfig;
        }
      )
      (builtins.attrNames dotfiles-private.users)
  );
in
{
  users.users = generateNixOSUserAccounts;
}
