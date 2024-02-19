# Tracteur's dotfiles
Nix flakes based dotfiles. This configuration has been cobbled together from a variety of sources. It's a beautiful mess.

## Hosts
- `aurora` - Microsoft Surface Laptop Studio 2021
- `spartanfall` - Desktop PC (Intel i9-12900K + AMD 6900XT)

## Setup
### dotfiles-private
The dotfiles-private flake separates out the private configuration from the public configuration. This is useful for things like usernames, emails, and other private information. Don't use it for secrets like passwords or keys. 

<details>
<summary>A minimalist example dotfiles-private</summary>

```nix
{
  description = "Private dotfiles";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dotfiles-utils = {
      url = "github:tracteurblinde/dotfiles-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { ... } :
  let
    pkgs = import <nixpkgs> {};
  {
    users = {
      "<userA>" = {
        nixosConfig = {
          isNormalUser = true;
          description = "<Display Name>";
          extraGroups = [ "networkmanager" "video" "audio" "wheel" "adbusers" "libvirtd" ];
        };
        homeConfig = {
          home.username = "<username>";
          home.homeDirectory = "/home/<username>";
        };
      };
      # Or use dotfiles-utils.generateUser which will also initialize git
      #   and setup the account picture and desktop background.
      "<userB"> = dotfiles-utils.generateUser rec {
        inherit pkgs;
        name = "<Display Name>";
        username = "<username>";
        email = "<email>";
        groups = [ "wheel" ];
        face = ./face.png;
        background = ./background.png;
      };
    };
    hardware = {
      "<host>".config = import ./hardware_configuration.nix;
    }
    homeCommon = {};
    nixosCommon = {};
  };
}
```
</details>

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

- Prismalauncher: https://github.com/catppuccin/prismlauncher
- Librewolf
  - Browser themed using firefox color: https://github.com/catppuccin/firefox
  - Sites themed using Stylus: https://github.com/catppuccin/userstyles/tree/main
    - Edit stylus config to add custom Forgejo (Codeberg), Mastodon, and SearxNG domains.
    - Since Librewolf will lightmode everything, some sites will require dark mode configured in the site's settings. Alternatively, the stylus settings for that site/theme can be used to set `mocha` as the light theme. In either case, Stylus settings should be modified to set `lavender` as the accent color. Suggested sites:
      - Codeberg
      - Github
      - Gmail / Google
      - Mastodon
      - Nitter
      - NixOS Search
      - NixOS Wiki
      - Proton
      - SearXNG
      - Twitch
      - YouTube
  - Anything else themed with Dark Reader: https://github.com/catppuccin/dark-reader
    - Don't download anything, use the instructions to enable the built-in catppuccin theme since that's mocha
    - Then set Dark Reader to detect dark themes.
- Vesktop: https://catppuccin.github.io/discord/dist/catppuccin-mocha-lavender.theme.css

### Manual Configuration
- Use `protonup-qt` to configure Proton-GE with Steam.
- `chatterino` requires manual configuration of the auth token and tab layout for the streamers you follow.
- `talon` requires pulling the community config, following the instructions from [talonhub/community](https://github.com/talonhub/community).

## Convenience scripts
```sh
./update.sh # Just does `nix flake update`
./switch.sh # nixos and home-manager switch
```

## Todo:
### Known Issues
- [ ] Path of Building has no icon, must be launched by running `pobfrontend`
### Missing Configuration
- [ ] chatterino
  - Auth isn't separated into another file
- [ ] input-leap
- [ ] Fluent Reader
- [ ] streamlink
  - this setup might just be the chatterino setup to embed the auth token. May end up as a manual step.
- [ ] Talon Voice
  - Talon wants write access to the configuration files :/
- [ ] Vencord configuration
  - Theme: `https://catppuccin.github.io/discord/dist/catppuccin-mocha-lavender.theme.css`
  - Currently using cloud sync, but it'd be nice to codify it in nix
### Scratch
- [ ] Gnome -> Hyprland
  - TBH, Gnome has been waaay more our style than KDE so far
  - But we're still intrigued by Hyprland
  - https://wiki.hyprland.org/Configuring/Example-configurations/