# Based on https://github.com/rxyhn/yuki/blob/46f79ed9f160b77e0401c0f109b4f3295501bdeb/home/modules/programs/firefox.nix
{ pkgs, ... }:
let
  mimeTypes = [
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
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
  home.sessionVariables.BROWSER = "librewolf";
  home.sessionVariables.DEFAULT_BROWSER = "librewolf";

  xdg.mimeApps.defaultApplications = builtins.listToAttrs (map
    (mimeType: {
      name = mimeType;
      value = [ "librewolf.desktop" ];
    })
    mimeTypes);

  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false;
      "identity.fxaccounts.enabled" = true;
    };
  };
}
