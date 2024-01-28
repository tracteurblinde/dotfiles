{ config, pkgs, lib, ... }:

{

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fish = {
    enable = true;

    shellAliases = {
      ls = "eza";
      l = "eza -F";
      la = "eza -a";
      ll = "eza -lgh";
      lla = "eza -lgha";
      llt = "eza -lghrs modified";
      lt = "eza -ThlgL 3";
      less = "less -S";
      top = "htop";
      todo = "task todo";
      version = "date '+%Y%m%d%H%M%S'";
      vclip = "xclip -selection clipboard";
      df = "df -h";

      timestamp = "date +%Y%m%d%H%M%S";

      nix-search = "nix-env -qaP";
      nix-list = "nix-env -qaP \"*\" --description";
      nix-list-haskell = "nix-env -f \"<nixpkgs>\" -qaP -A haskellPackages";
      nix-list-node = "nix-env -f \"<nixpkgs>\" -qaP -A nodePackages";
      nix-find = "clear ; ${pkgs.nix-index}/bin/nix-locate -1 -w";

      nix-show-garbage-roots = "ls -lh /nix/var/nix/gcroots/auto/";
    };
  };
}
