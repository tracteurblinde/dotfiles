final: prev:
let
  pkgs = prev;
in
rec {
  # nixpkgs only exposes cura 4 due to difficulties with the cura 5 build system
  # Just use the appimage for now
  # Based on @MarSoft https://github.com/NixOS/nixpkgs/issues/186570#issuecomment-1627797219
  cura = (
    let
      cura5 = pkgs.appimageTools.wrapType2 rec {
        name = "cura5";
        version = "5.7.2";
        tag = "${version}-RC2";
        src = pkgs.fetchurl {
          url = "https://github.com/Ultimaker/Cura/releases/download/${tag}/UltiMaker-Cura-${version}-linux-X64.AppImage";
          hash = "sha256-XlTcCmIqcfTg8fxM2KDik66qjIKktWet+94lFIJWopY=";
        };
        extraPkgs = pkgs: with pkgs; [ ];
      };
    in
    pkgs.writeScriptBin "cura" ''
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
    ''
  );

  retroarch = pkgs.retroarch.override {
    cores = with pkgs.libretro; [
      vba-next
    ];
  };
}
