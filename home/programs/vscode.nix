{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium;

    userSettings = {
      "catppuccin.accentColor" = "mauve";
      "cSpell.enableFiletypes" = [ "nix" ];
      "cSpell.textDecorationStyle" = "dashed";
      "cSpell.userWords" = [
        "tracteur"
        "blindé"
        "tracteurblinde"
        "devshell"
        "nixos"
        "nixpkgs"
        "numtide"
        "pkgs"
        "stdenv"
        "venv"
      ];
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.formatOnSave" = true;
      "editor.fontFamily" = "'MonaspiceNe Nerd Font Mono', 'monospace', monospace";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "github.copilot.chat.scopeSelection" = true;
      "github.copilot.editor.enableAutoCompletions" = true;
      "github.copilot.enable" = {
        "*" = true;
        "plaintext" = false;
        "markdown" = true;
        "scminput" = false;
      };
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
      "black-formatter.args" = [ "--line-length=119" ];
      "isort.args" = [ "--profile" "black" "--line-length" "119" "--skip-gitignore" ];
      "[python]" = {
        "editor.codeActionsOnSave" = {
          "source.organizeImports" = "explicit";
        };
        "editor.defaultFormatter" = "ms-python.black-formatter";
      };

    };

    extensions = with pkgs.vscode-extensions; [
      # Themes
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons

      # Utility
      aaron-bond.better-comments
      eamodio.gitlens
      mkhl.direnv
      twxs.cmake
      wakatime.vscode-wakatime

      # Python
      ms-python.black-formatter
      ms-python.debugpy
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance

      # Rust
      rust-lang.rust-analyzer
      #serayuzgur.crates
      vadimcn.vscode-lldb

      # Typescript
      dbaeumer.vscode-eslint
      svelte.svelte-vscode

      # Other Languages
      bbenoist.nix
      streetsidesoftware.code-spell-checker
      tamasfe.even-better-toml
      yzhang.markdown-all-in-one

      # Copilot
      github.copilot
      github.copilot-chat

      # We really like remote ssh in vscode
      ms-vscode-remote.remote-ssh
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "command-server";
        publisher = "pokey";
        version = "0.10.1";
        sha256 = "r70WXsr5+aHv+W5aT6m7NcaEtte1dnWhRyxWWhu0uLM=";
      }
      {
        name = "cursorless";
        publisher = "pokey";
        version = "0.28.1207";
        sha256 = "sha256-2quqZe0Ax99iFTdB4RL0l6XhKLd//s9wyZtp8PZgsoQ=";
      }
      {
        name = "parse-tree";
        publisher = "pokey";
        version = "0.31.1";
        sha256 = "sha256-WasaTsumg2g06upRlA3NjdEjZkmL+OvxL7Trp3Gl+Sk=";
      }
      {
        name = "prettify-json";
        publisher = "mohsen1";
        version = "0.0.3";
        sha256 = "lvds+lFDzt1s6RikhrnAKJipRHU+Dk85ZO49d1sA8uo=";
      }
      {
        name = "remote-explorer";
        publisher = "ms-vscode";
        version = "0.4.3";
        sha256 = "772l0EnAWXLg53TxPZf93js/W49uozwdslmzNwD1vIk=";
      }
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.86.0";
        sha256 = "JsbaoIekUo2nKCu+fNbGlh5d1Tt/QJGUuXUGP04TsDI=";
      }
      {
        name = "rust-targets";
        publisher = "polymeilex";
        version = "1.1.1";
        sha256 = "htmIQhtig5tunUwonow7xqRUXoCE6faEOzK0h6NXM20=";
      }
      {
        name = "tauri-vscode";
        publisher = "tauri-apps";
        version = "0.2.6";
        sha256 = "O9NxFemUgt9XmhL6BnNArkqbCNtHguSbvVOYwlT0zg4=";
      }
      {
        name = "vscode-fileutils";
        publisher = "sleistner";
        version = "3.10.3";
        sha256 = "v9oyoqqBcbFSOOyhPa4dUXjA2IVXlCTORs4nrFGSHzE=";
      }
      {
        name = "vscode-mogami";
        publisher = "ninoseki";
        version = "0.0.29";
        sha256 = "sha256-XSOiAMOYC2lUKv/xYYH/9pCRNMySD3pLp/HT/3F7pGo=";
      }
    ];
  };
}
