{ inputs, lib, pkgs, ... }:
{
  imports = [
  ];

  # Allow _some_ unfree packages
  nixpkgs.allowUnfreePackages = [
    "aspell-dict-en-science"
  ];

  # Acknowledge insecure packages
  nixpkgs.permittedInsecurePackages = [
  ];

  home.packages = with pkgs; [
    (aspellWithDicts (dicts: [
      dicts.en
      dicts.fr
      dicts.en-computers
      dicts.en-science
    ]))

    # Terminal
    fastfetch
  ];
}
