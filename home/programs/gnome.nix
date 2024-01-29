# Based on https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
{ pkgs, ... }:

let
  catppuccin-lavender-mocha = pkgs.catppuccin-gtk.override {
    accents = [ "lavender" ];
    size = "compact";
    tweaks = [ "rimless" "normal" ];
    variant = "mocha";
  };

  catppuccin-icons-lavender-mocha = pkgs.catppuccin-papirus-folders.override {
    accent = "lavender";
    flavor = "mocha";
  };
in
{
  home.packages = with pkgs; [
    catppuccin-lavender-mocha
    catppuccin-icons-lavender-mocha
    catppuccin-cursors.mochaLavender

    gnome.gnome-tweaks
    gnome.gnome-themes-extra

    gnomeExtensions.appindicator
    gnomeExtensions.gamemode-indicator-in-system-settings
    gnomeExtensions.gsconnect
    gnomeExtensions.kimpanel
    gnomeExtensions.openweather # Currently disabled while waiting on Gnome 45 support
    gnomeExtensions.tiling-assistant
    gnomeExtensions.transparent-window-moving
  ];

  # Sets the dconf settings for the current user
  # Found by running `dconf watch /` and changing settings :)
  dconf.settings = {
    "org/gnome/shell" = {
      "disable-user-extensions" = false;
      "enabled-extensions" = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "gsconnect@andyholmes.github.io"
        "gmind@tungstnballon.gitlab.com"
        "kimpanel@kde.org"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "tiling-assistant@leleat-on-github"
        "transparent-window-moving@noobsai.github.com"
      ];
      "favorite-apps" = [
        "org.gnome.Nautilus.desktop"
        "librewolf.desktop"
        "kitty.desktop"
        "code.desktop"
        "Trilium.desktop"
      ];
    };
    # Pretty Windows-y keybindings, since that's what we're familiar with
    "org/gnome/desktop/wm/keybindings" = {
      "move-to-workspace-left" = [ "<Shift><Control><Super>Left" ];
      "move-to-workspace-right" = [ "<Shift><Control><Super>Right" ];
      "switch-to-workspace-left" = [ "<Control><Super>Left" ];
      "switch-to-workspace-right" = [ "<Control><Super>Right" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      "theme" = "Catppuccin-Mocha-Compact-Lavender-Dark";
      "titlebar-font" = "LiterationSans Nerd Font Propo Bold 11";
    };
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
      "cursor-theme" = "Catppuccin-Mocha-Lavender-Cursors";
      "icon-theme" = "Papirus-Dark";
      "gtk-theme" = "Catppuccin-Mocha-Compact-Lavender-Dark";

      "font-antialiasing" = "rgba";
      "font-name" = "LiterationSans Nerd Font Propo 10";
      "document-font-name" = "LiterationSans Nerd Font Propo 11";
      "monospace-font-name" = "MonaspiceNe Nerd Font Mono 10";
    };
    "org/gnome/desktop/notifications" = {
      "show-in-lock-screen" = false;
    };
    "org/gnome/mutter" = {
      "edge-tiling" = true;
    };
  };
}
