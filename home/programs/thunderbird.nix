{ pkgs, ... }:
let
  mimeTypes = [
    "x-scheme-handler/mailto"
    "message/rfc822"
    "application/x-extension-eml"
  ];
in
{
  # Violet claims there are no ENV equivalents and a quick grep didn't find any
  #home.sessionVariables.MAILER = "thunderbird";
  #home.sessionVariables.DEFAULT_MAILER = "thunderbird";

  xdg.mimeApps.defaultApplications = builtins.listToAttrs (map
    (mimeType: {
      name = mimeType;
      value = [ "thunderbird.desktop" ];
    })
    mimeTypes);

  home.packages = with pkgs; [
    thunderbird
    birdtray
    protonmail-bridge-gui
  ];

  # TODO: Use HM to configure this!
  #   Accounts are a requirement for using home-manager to manage Thunderbird
  #   We haven't migrated that in yet.
  programs.thunderbird = {
    # enable = true;
  };
}
