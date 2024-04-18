# Based on https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
{ pkgs, ... }:

let
  catppuccin-mauve-mocha = pkgs.catppuccin-gtk.override {
    accents = [ "mauve" ];
    size = "compact";
    tweaks = [ "rimless" "normal" ];
    variant = "mocha";
  };

  catppuccin-icons-mauve-mocha = pkgs.catppuccin-papirus-folders.override {
    accent = "mauve";
    flavor = "mocha";
  };
in
{
  home.packages = with pkgs; [
    catppuccin-mauve-mocha
    catppuccin-icons-mauve-mocha
    catppuccin-cursors.mochaMauve

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

  xdg.mimeApps.defaultApplications = {
    "archive/zip" = "org.gnome.FileRoller.desktop";
    "image/jpeg" = "org.gnome.Loupe.desktop";
    "image/png" = "org.gnome.Loupe.desktop";
    "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
    "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";
  };
  xdg.mimeApps.associations.added = {
    # GSConnect adds itself here at startup. For ease of use, we add it here
    "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
    "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";
  };

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
      "theme" = "Catppuccin-Mocha-Compact-Mauve-Dark";
      "titlebar-font" = "LiterationSans Nerd Font Propo Bold 11";
    };
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
      "cursor-theme" = "Catppuccin-Mocha-Mauve-Cursors";
      "icon-theme" = "Papirus-Dark";
      "gtk-theme" = "Catppuccin-Mocha-Compact-Mauve-Dark";

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
