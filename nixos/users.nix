{ config, pkgs, lib, dotfiles-private, dotfiles-utils, ... }@inputs:
let
  userModules = builtins.listToAttrs (
    builtins.map
      (user:
        let
          user_module = dotfiles-private.users.${user} { inherit pkgs dotfiles-utils; };
        in
        {
          name = user;
          value = user_module;
        }
      )
      (builtins.attrNames dotfiles-private.users)
  );
  generateNixOSUserAccounts = builtins.listToAttrs (
    builtins.map
      (user:
        {
          name = user;
          value = userModules.${user}.nixosConfig;
        }
      )
      (builtins.attrNames userModules)
  );
  wheeledUserAccounts = builtins.filter (user: user != null) (
    builtins.map
      (user:
        if (builtins.elem "wheel" userModules.${user}.nixosConfig.extraGroups)
        then user
        else null
      )
      (builtins.attrNames userModules)
  );
in
{
  users.users = generateNixOSUserAccounts;
  nix.settings.trusted-users = wheeledUserAccounts;
}
