# Tracteur's dotfiles
Nix flakes based dotfiles. This configuration has been cobbled together from a variety of sources. It's a beautiful mess.

## Hosts
- `aurora` - Microsoft Surface Laptop Studio 2021
- `spartanfall` - Desktop PC (Intel i9-12900K + AMD 6900XT)

## Setup
### dotfiles-private
You will have to overwrite the dotfiles-private flake with your own. A minimalist flake would look like

```nix
{
  description = "Private dotfiles";
  inputs = {};
  outputs = { ... } :
  {
    users = {
      "<user"> = {
        home.user = "<user>";
        home.homeDirectory = "/home/<user>";
      };
    };
    hardware = {
      "<host>" = import ./hardware_configuration.nix;
    }
  };
}
```

### nixos
*Root will need to be able to login to private repos.*

```sh
sudo ln -s <path/to>/dotfiles /etc/nixos 
sudo nix run nixpkgs#sbctl create-keys
sudo nixos-rebuild boot --flake '.#<host>'
```

### home-manager
Home manager uses the same flake but is not configured as a nixos module.
```sh
ln -s <path/to>/dotfiles ~/.config/home-manager 
home-manager switch --flake '.#<user>@<host>'
```

### Manual Theming
In general, everything is themed with the Mocha Catppuccin theme using the Lavender accent.

- Librewolf
  - Themed using firefox color: https://github.com/catppuccin/firefox
  - Sites themed using Stylus: https://github.com/catppuccin/userstyles/tree/main
    - Edit stylus config to add custom Forgejo (Codeberg), Mastodon, and SearxNG domains.
    - Since Librewolf will lightmode everything, for some sites you use you will need to either need to set your theme to dark mode in the site's settings or you need set mocha as the light theme. For our uses:
      - Codeberg
      - Github
      - NixOS Search
      - NixOS Wiki
      - Proton
      - SearXNG
      - YouTube
  - Anything else themed with Dark Reader: https://github.com/catppuccin/dark-reader
    - Don't download anything, use the instructions to enable the built-in catppuccin theme since that's mocha
    - Then set Dark Reader to detect dark themes.
- Prismalauncher: https://github.com/catppuccin/prismlauncher


## Convenience scripts
```sh
./update.sh # Just does `nix flake update`
./switch.sh # nixos and home-manager switch
```

## Todo:
- [ ] Gnome -> Hyprland
  - TBH, Gnome has been waaay more our style than KDE so far
  - But we're still intrigued by Hyprland
  - https://wiki.hyprland.org/Configuring/Example-configurations/
- [ ] Vencord configuration
  - Theme: `https://catppuccin.github.io/discord/dist/catppuccin-mocha-lavender.theme.css`
  - Currently using cloud sync, but it'd be nice to codify it in nix
- [ ] chatterino
  - Auth isn't separated into another file
- [ ] streamlink
  - this setup might just be the chatterino setup to embed the auth token
- [ ] input-leap
  - Spartanfall and Aurora need different configs
  - ~~Aurora might be configurable with `services.barrier.client = { enable = true; server = 'spartanfall'; };`~~
  - input-leap doesn't have a home-manager config + we moved it to the nixos side for firewall reasons
  