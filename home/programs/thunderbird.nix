{ pkgs, ... }:
let
  # ```
  # diff -u ~/.config/mimeapps.list*                                                                                                                                                                        ✔ 
  # --- ~/.config/mimeapps.list    1969-12-31 16:00:01.000000000 -0800
  # +++ ~/.config/mimeapps.list.backup     2024-09-10 14:51:25.571880674 -0700
  # @@ -1,6 +1,16 @@
  #  [Added Associations]
  #  x-scheme-handler/sms=org.gnome.Shell.Extensions.GSConnect.desktop
  #  x-scheme-handler/tel=org.gnome.Shell.Extensions.GSConnect.desktop
  # +x-scheme-handler/mailto=userapp-Thunderbird-IKVZT2.desktop;
  # +x-scheme-handler/mid=userapp-Thunderbird-IKVZT2.desktop;
  # +x-scheme-handler/news=userapp-Thunderbird-LKC2T2.desktop;
  # +x-scheme-handler/snews=userapp-Thunderbird-LKC2T2.desktop;
  # +x-scheme-handler/nntp=userapp-Thunderbird-LKC2T2.desktop;
  # +x-scheme-handler/feed=userapp-Thunderbird-11S3T2.desktop;
  # +application/rss+xml=userapp-Thunderbird-11S3T2.desktop;
  # +application/x-extension-rss=userapp-Thunderbird-11S3T2.desktop;
  # +x-scheme-handler/webcal=userapp-Thunderbird-TS73T2.desktop;
  # +x-scheme-handler/webcals=userapp-Thunderbird-TS73T2.desktop;

  #  [Default Applications]
  #  application/x-extension-htm=librewolf.desktop
  # @@ -25,5 +35,18 @@
  #  x-scheme-handler/tel=org.gnome.Shell.Extensions.GSConnect.desktop
  #  x-scheme-handler/tidal=tidal-hifi.desktop
  #  x-scheme-handler/unknown=librewolf.desktop
  # +x-scheme-handler/mailto=userapp-Thunderbird-IKVZT2.desktop
  # +message/rfc822=userapp-Thunderbird-IKVZT2.desktop
  # +x-scheme-handler/mid=userapp-Thunderbird-IKVZT2.desktop
  # +x-scheme-handler/news=userapp-Thunderbird-LKC2T2.desktop
  # +x-scheme-handler/snews=userapp-Thunderbird-LKC2T2.desktop
  # +x-scheme-handler/nntp=userapp-Thunderbird-LKC2T2.desktop
  # +x-scheme-handler/feed=userapp-Thunderbird-11S3T2.desktop
  # +application/rss+xml=userapp-Thunderbird-11S3T2.desktop
  # +application/x-extension-rss=userapp-Thunderbird-11S3T2.desktop
  # +x-scheme-handler/webcal=userapp-Thunderbird-TS73T2.desktop
  # +text/calendar=userapp-Thunderbird-TS73T2.desktop
  # +application/x-extension-ics=userapp-Thunderbird-TS73T2.desktop
  # +x-scheme-handler/webcals=userapp-Thunderbird-TS73T2.desktop
  # ```
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
    #thunderbird
    birdtray
    protonmail-bridge-gui
  ];

  # TODO: Use HM to configure this!
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;

    };
  };
}
