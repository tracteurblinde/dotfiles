{ config, inputs, lib, pkgs, nixpkgs, ... }:

{
  # Bootloader.
  boot = {
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = lib.mkForce false;
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the KDE Plasma Desktop Environment.
    #displayManager.sddm.enable = true;
    #displayManager.defaultSession = "plasmawayland";
    #desktopManager.plasma5.enable = true;

    # Gnome
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable HW Graphics acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  services.libinput = {
    enable = true;
    touchpad = {
      accelProfile = "adaptive";
      disableWhileTyping = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable polkit to allow wayland in home-manager
  security.polkit.enable = true;

  services.udev = {
    # Gnome udev rules
    packages = [ pkgs.gnome.gnome-settings-daemon ];

    extraRules = ''
      # Allow users raw HID access to ZSA keyboards
      KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="users"
      KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="users"
      # Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
    '';
  };

  networking.firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 22716 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 22716 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 22716 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 22716 -j RETURN || true
    '';

    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect / GSConnect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect / GSConnect
    ];
  };

  # Unfree packages
  nixpkgs.allowUnfreePackages = [
    "steam"
    "steam-original"
    "steam-run"
    "vista-fonts"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    htop
    busybox

    fcitx5
    gnome-network-displays
    input-leap

    # Gaming
    # steam is configured below
    (lutris.override {
      extraPkgs = pkgs: [
        # List package dependencies here
      ];
      extraLibraries = pkgs: [
        # List library dependencies here
        pango
      ];
    })
    mangohud
    protontricks
    winetricks
    wineWowPackages.stable
    wineWowPackages.waylandFull
  ];


  fonts.packages = with pkgs; [
    ibm-plex
    (nerdfonts.override {
      fonts = [ "LiberationMono" "Monaspace" ];
    })
    vistafonts # For compat with MSOffice documents
  ];

  environment.sessionVariables = rec {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
  };

  # Disable a bunch of gnome packages we don't need
  environment.gnome.excludePackages = (with pkgs; [
    cheese # webcam tool
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gnome-photos
    gnome-terminal
    gnome-tour
    gedit # text editor
    totem # video player
  ]) ++ (with pkgs.gnome; [
    gnome-music
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  programs.adb.enable = true;
  programs.gamemode.enable = true;

  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  #   portalPackage = inputs.xdg-desktop-portal-hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  # };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
      };
    };
  };
}
