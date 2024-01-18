{ inputs, pkgs, environment, ... }:

let
  illogical_impulse = ./3pp/dots-hyprland;
in
{
  # This is https://github.com/end-4/dots-hyprland/wiki/illogical_impulse
  #   just configured as a nix module
  # FIXME: THIS IS OUT OF DATE

  # AGS is a required dependency for this setup
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  #wayland.windowManager.hyprland.enable = true;

  home.packages = with pkgs; [
    brightnessctl
    cava
    #fcitx5 # Moved to system
    gnome.gnome-keyring
    gojq
    grim
    gtklock
    gtklock-playerctl-module
    gtklock-powerbar-module
    gtklock-userinfo-module
    lexend
    material-symbols
    playerctl
    polkit_gnome
    ripgrep
    sassc
    slurp
    swayidle
    swww
    tesseract
    upower
    webp-pixbuf-loader
    wireplumber
    wl-clipboard
    wlogout
    yad
    ydotool
  ];

  programs.ags = {
    enable = true;

    # packages to add to gjs's runtime
    extraPackages = with pkgs; [
      libnotify
      libsoup_3
    ];
  };

  home.file.".config/ags" = {
    source = "${illogical_impulse}/.config/ags";
    recursive = true;
  };

  # home.file.".config/fish" = {
  #   source = "${illogical_impulse}/.config/fish";
  #   recursive = true;
  # };

  home.file.".config/fontconfig" = {
    source = "${illogical_impulse}/.config/fontconfig";
    recursive = true;
  };

  # home.file.".config/foot" = {
  #   source = "${illogical_impulse}/.config/foot";
  #   recursive = true;
  # };

  home.file.".config/fuzzel" = {
    source = "${illogical_impulse}/.config/fuzzel";
    recursive = true;
  };

  home.file.".config/gtklock" = {
    source = "${illogical_impulse}/.config/gtklock";
    recursive = true;
  };

  home.file.".config/hypr" = {
    source = "${illogical_impulse}/.config/hypr";
    recursive = true;
  };

  home.file.".config/mpv" = {
    source = "${illogical_impulse}/.config/mpv";
    recursive = true;
  };

  home.file.".config/wlogout" = {
    source = "${illogical_impulse}/.config/wlogout";
    recursive = true;
  };

  home.file.".config/code-flags.conf" = {
    source = "${illogical_impulse}/.config/code-flags.conf";
  };

  home.file.".config/starship.toml" = {
    source = "${illogical_impulse}/.config/starship.toml";
  };

  home.file.".local/bin/fuzzel-emoji" = {
    source = "${illogical_impulse}/.local/bin/fuzzel-emoji";
    executable = true;
  };

  home.file.".local/bin/rubyshot" = {
    source = "${illogical_impulse}/.local/bin/rubyshot";
    executable = true;
  };

}

