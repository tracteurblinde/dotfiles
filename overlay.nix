final: prev:
let
  pkgs = prev;
in
rec {
  # nixpkgs only exposes cura 4 due to difficulties with the cura 5 build system
  # Just use the appimage for now
  # From @MarSoft https://github.com/NixOS/nixpkgs/issues/186570#issuecomment-1627797219
  cura = (
    let
      cura5 = pkgs.appimageTools.wrapType2 rec {
        name = "cura5";
        version = "5.7.1";
        src = pkgs.fetchurl {
          url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
          hash = "sha256-LZMD0fo8TSlDEJspvTka724lYq5EgrOlDkwMktXqATw=";
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

  iptsd = pkgs.iptsd.overrideAttrs (old: rec {
    version = "2";

    src = pkgs.fetchFromGitHub {
      owner = "linux-surface";
      repo = "iptsd";
      rev = "v${version}";
      hash = "sha256-zTXTyDgSa1akViDZlYLtJk1yCREGCSJKxzF+HZAWx0c=";
    };
  });

  libwacom-surface-patches = pkgs.fetchFromGitHub {
    owner = "linux-surface";
    repo = "libwacom-surface";
    rev = "v2.10.0-1";
    hash = "sha256-5/9X20veXazXEdSDGY5aMGQixulqMlC5Av0NGOF9m98=";
  };

  libwacom-surface = pkgs.libwacom.overrideAttrs (old: {
    pname = "libwacom-surface";

    # These patches will not be included upstream:
    # https://github.com/linux-surface/libwacom/issues/2
    patches = old.patches or [ ] ++ map (p: "${libwacom-surface-patches}/patches/v2/${p}") [
      "0001-Add-support-for-BUS_VIRTUAL.patch"
      "0002-Add-support-for-Intel-Management-Engine-bus.patch"
      "0003-data-Add-Microsoft-Surface-Pro-3.patch"
      "0004-data-Add-Microsoft-Surface-Pro-4.patch"
      "0005-data-Add-Microsoft-Surface-Pro-5.patch"
      "0006-data-Add-Microsoft-Surface-Pro-6.patch"
      "0007-data-Add-Microsoft-Surface-Pro-7.patch"
      "0008-data-Add-Microsoft-Surface-Pro-7.patch"
      "0009-data-Add-Microsoft-Surface-Pro-8.patch"
      "0010-data-Add-Microsoft-Surface-Pro-9.patch"
      "0011-data-Add-Microsoft-Surface-Book.patch"
      "0012-data-Add-Microsoft-Surface-Book-2-13.5.patch"
      "0013-data-Add-Microsoft-Surface-Book-2-15.patch"
      "0014-data-Add-Microsoft-Surface-Book-3-13.5.patch"
      "0015-data-Add-Microsoft-Surface-Book-3-15.patch"
      "0016-data-Add-Microsoft-Surface-Laptop-Studio.patch"
    ];
  });

  # Workaround while awaiting https://github.com/NixOS/nixpkgs/pull/307294
  protonup-qt =
    let
      pname = "protonup-qt";
      version = "2.9.2";
      src = pkgs.fetchurl {
        url = "https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v${version}/ProtonUp-Qt-${version}-x86_64.AppImage";
        hash = "sha256-d1UjyhU7BezOoQZBnmrk96gD0MbYST0XR+PWVYmvGFQ=";
      };
      appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
    in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        mkdir -p $out/share/{applications,pixmaps}
        cp ${appimageContents}/net.davidotek.pupgui2.desktop $out/share/applications/${pname}.desktop
        cp ${appimageContents}/net.davidotek.pupgui2.png $out/share/pixmaps/${pname}.png
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=net.davidotek.pupgui2' 'Exec=${pname}' \
          --replace 'Icon=net.davidotek.pupgui2' 'Icon=${pname}'
      '';

      extraPkgs = pkgs: with pkgs; [ zstd ];
    };

  retroarch = pkgs.retroarch.override {
    cores = with pkgs.libretro; [
      vba-next
    ];
  };
}
