{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium;

    userSettings = {
      "catppuccin.accentColor" = "lavender";
      "cSpell.enableFiletypes" = [ "nix" ];
      "cSpell.userWords" = [
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
      eamodio.gitlens
      twxs.cmake
      wakatime.vscode-wakatime

      # Python
      ms-python.black-formatter
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance

      # Rust
      rust-lang.rust-analyzer
      serayuzgur.crates
      vadimcn.vscode-lldb


      # Typescript
      dbaeumer.vscode-eslint


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
        name = "better-comments";
        publisher = "aaron-bond";
        version = "3.0.2";
        sha256 = "hQmA8PWjf2Nd60v5EAuqqD8LIEu7slrNs8luc3ePgZc=";
      }
      {
        name = "prettify-json";
        publisher = "mohsen1";
        version = "0.0.3";
        sha256 = "lvds+lFDzt1s6RikhrnAKJipRHU+Dk85ZO49d1sA8uo=";
      }
      {
        name = "rust-targets";
        publisher = "polymeilex";
        version = "1.1.1";
        sha256 = "htmIQhtig5tunUwonow7xqRUXoCE6faEOzK0h6NXM20=";
      }
      {
        name = "remote-explorer";
        publisher = "ms-vscode";
        version = "0.4.1";
        sha256 = "E0QsXIpCUjpoX6GNtzbI8/UzxTwWMpQpzVvsPhA+3t4=";
      }
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.86.0";
        sha256 = "JsbaoIekUo2nKCu+fNbGlh5d1Tt/QJGUuXUGP04TsDI=";
      }
    ];
  };
}
