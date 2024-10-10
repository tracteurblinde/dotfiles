{ inputs, lib, pkgs, ... }:
{
  imports = [
    ../programs/gnome.nix
    #../programs/hyprland.nix
    ../programs/librewolf.nix
    ../programs/thunderbird.nix
    ../programs/vscode.nix
  ];

  # Allow _some_ unfree packages
  nixpkgs.allowUnfreePackages = [
    "discord"
    "gitkraken"
    "obsidian"
    "parsec-bin"
    "plex-desktop"
    "slack"

    "aspell-dict-en-science"

    "vscode"
    "vscode-extension-github-copilot"
    "vscode-extension-github-copilot-chat"
    "vscode-extension-ms-vscode-remote-remote-ssh"
    "vscode-extension-MS-python-vscode-pylance"
  ];

  # Acknowledge insecure packages
  nixpkgs.permittedInsecurePackages = [
    "olm-3.2.16" # Required for element-desktop (and fluffychat?)
    "fluffychat-linux-1.22.1"
  ];

  home.packages = with pkgs; [
    (aspellWithDicts (dicts: [
      dicts.en
      dicts.fr
      dicts.en-computers
      dicts.en-science
    ]))

    # Terminal
    fastfetch
    kitty
    kitty-themes

    # Productivity Suite
    anki-bin
    cura
    chromium
    libreoffice
    fluent-reader
    krita
    obsidian
    peazip
    qbittorrent
    qdirstat
    tenacity
    trilium-desktop
    filezilla

    # Chat
    chatterino2
    element-desktop
    fluffychat
    slack
    vesktop

    # Media
    mpv
    plex-desktop
    streamlink
    tidal-hifi

    #Gaming
    parsec-bin
    path-of-building
    prismlauncher
    protonup-qt
    retroarch

    # Development GUI
    gitkraken
    gnome-multi-writer
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
    ".config/mpv/mpv.conf".source = ../dotfiles/mpv.conf;
    ".config/MangoHud/MangoHud.conf".source = ../dotfiles/MangoHud.conf;
  };

  home.sessionVariables = {
    TERM = "xterm-256color";

    NIXOS_OZONE_WL = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";


    # WA for missing window decorations in kitty under gnome
    #   https://github.com/kovidgoyal/kitty/issues/1645
    KITTY_DISABLE_WAYLAND = "1";
  };

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/element" = "element-desktop.desktop";
      "x-scheme-handler/ftp" = "filezilla.desktop";
      "x-scheme-handler/magnet" = "qbittorrent.desktop";
      "x-scheme-handler/tidal" = "tidal-hifi.desktop";
    };
  };
}
