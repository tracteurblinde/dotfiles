{ inputs, lib, pkgs, ... }:
let
  # Pending v0.63.1 beta release: https://github.com/zadam/trilium/releases
  trilium-desktop-beta = pkgs.trilium-desktop.overrideAttrs (oldAttrs: rec {
    version = "0.63.1-beta";
    src = pkgs.fetchurl {
      url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz";
      sha256 = "0v5vwr8s11pq0dz35mwgydncf05wc07psg506q61z2fq9i99kkg2";
    };
  });

  # nixpkgs only exposes cura 4 due to difficulties with the cura 5 build system
  # Just use the appimage for now
  # From @MarSoft https://github.com/NixOS/nixpkgs/issues/186570#issuecomment-1627797219
  cura5 = (let cura5 = pkgs.appimageTools.wrapType2 rec {
      name = "cura5";
      version = "5.6.0";
      src = pkgs.fetchurl {
        url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
        hash = "sha256-EHiWoNpLKHPzv6rZrtNgEr7y//iVcRYeV/TaCn8QpEA=";
      };
      extraPkgs = pkgs: with pkgs; [ ];
    }; in pkgs.writeScriptBin "cura" ''
      #! ${pkgs.bash}/bin/bash
      # AppImage version of Cura loses current working directory and treats all paths relative to $HOME.
      # So we convert each of the files passed as argument to an absolute path.
      # This fixes use cases like `cd /path/to/my/files; cura my_model.stl another_model.stl`.
      args=()
      for a in "$@"; do
        if [ -e "$a" ]; then
          a="$(realpath "$a")"
        fi
        args+=("$a")
      done
      exec "${cura5}/bin/cura5" "''${args[@]}"
    '');
in
{
  imports = [
    ./programs/fish.nix
    ./programs/gnome.nix
    #./programs/hyprland.nix
    ./programs/vscode.nix
    ./programs/zsh.nix
  ];

  # Allow _some_ unfree packages
  nixpkgs.allowUnfreePackages = [
    "discord"
    "gitkraken"
    "parsec-bin"

    "vscode"
    "vscode-extension-github-copilot"
    "vscode-extension-github-copilot-chat"
    "vscode-extension-ms-vscode-remote-remote-ssh"
    "vscode-extension-MS-python-vscode-pylance"
  ];

  # Acknowledge insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9" # For etcher
  ];

  home.packages = with pkgs; [
    (aspellWithDicts (dicts: [
      dicts.en
      dicts.fr
      dicts.en-computers
      dicts.en-science
    ]))

    # Terminal
    eza
    fastfetch
    kitty
    kitty-themes
    tmux

    # Productivity Suite
    cura5
    chromium
    libreoffice
    fluent-reader
    krita
    peazip
    qbittorrent
    qdirstat
    tenacity
    trilium-desktop-beta
    filezilla

    # Chat
    chatterino2
    element-desktop
    fluffychat
    vesktop

    # Media
    mpv
    plex-media-player
    streamlink
    tidal-hifi

    #Gaming
    parsec-bin
    path-of-building
    prismlauncher
    protonup-qt

    # Development GUI
    gitkraken
    etcher
    rpi-imager

    # Development CLI
    (lib.hiPrio clang)
    clang-tools
    binutils
    cmake
    ctags
    gdb
    micropython
    mpremote
    ninja
    rustup

    # Other
    friture
  ];

  home.file = {
    ".config/mpv/mpv.conf".source = dotfiles/mpv.conf;
    ".config/MangoHud/MangoHud.conf".source = dotfiles/MangoHud.conf;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
    EDITOR = "nvim";
    PATH = "$HOME/.config/zsh/scripts:$HOME/.cargo/bin:$PATH";
    TERM = "xterm-256color";

    # WA for missing window decorations in kitty under gnome
    #   https://github.com/kovidgoyal/kitty/issues/1645
    KITTY_DISABLE_WAYLAND = "1";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
    };
  };

  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font.name = "MonaspiceKr Nerd Font Mono";
    shellIntegration = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    settings = {
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false;
      "identity.fxaccounts.enabled" = true;
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
}
