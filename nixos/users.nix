{ host }:
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
  hostUsernames = builtins.filter
    (user:
      # If the user has no hosts specified, they are assumed to be on all hosts.
      builtins.elem host (userModules.${user}.hosts or [ host ])
    )
    (builtins.attrNames userModules);
  generateNixOSUserAccounts = builtins.listToAttrs (
    builtins.map
      (user:
        {
          name = user;
          value = userModules.${user}.nixosConfig;
        }
      )
      hostUsernames
  );
  wheeledUserAccounts = builtins.filter (user: user != null) (
    builtins.map
      (user:
        if (builtins.elem "wheel" userModules.${user}.nixosConfig.extraGroups)
        then user
        else null
      )
      hostUsernames
  );
in
{
  users.users = generateNixOSUserAccounts;
  nix.settings.trusted-users = wheeledUserAccounts;
}
