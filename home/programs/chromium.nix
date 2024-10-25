{ pkgs, config, ... }:
let
  mimeTypes = [
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/x-extension-xht"
    "application/x-extension-xhtml"
    "application/xhtml+xml"
    "text/html"
    "text/xml"
    "x-scheme-handler/about"
    "x-scheme-handler/http"
    "x-scheme-handler/unknown"
    "x-scheme-handler/https"
  ];
in
{
  programs.chromium = {
    enable = true;
  };

  home.sessionVariables.BROWSER = "chromium-browser";
  home.sessionVariables.DEFAULT_BROWSER = "chromium-browser";

  xdg.mimeApps.defaultApplications = builtins.listToAttrs (map
    (mimeType: {
      name = mimeType;
      value = [ "chromium-browser.desktop" ];
    })
    mimeTypes);

}
