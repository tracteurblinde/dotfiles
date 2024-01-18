{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    oh-my-zsh = {
      enable = true;

      plugins = [
        "cabal"
        "docker"
        "git"
        "git-flow"
        "git-prompt"
        "gitignore"
        "pass"
        "screen"
        "sudo"
        "systemd"
        "taskwarrior"
        "tmux"
        "vi-mode"
        "wd"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];

    initExtra = ''
      # Powerlevel10k config
      source ~/.config/zsh/.p10k.zsh

      # When using kitty, use kitty's ssh wrapper
      [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

      export PATH="$PATH''${PATH:+:}${lib.concatStringsSep ":" config.home.sessionPath}"
    '';

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
  home.file.".config/zsh/.p10k.zsh".source = ../dotfiles/zsh/.p10k.zsh;
}

