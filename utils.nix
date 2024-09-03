{ ... }:
rec {
  listDir = dir: builtins.attrNames (builtins.readDir dir);
  trimNixExts = configs: builtins.map (entry: builtins.substring 0 (builtins.stringLength entry - 4) entry) configs;
  findNixFilesInDir = dir: trimNixExts (builtins.filter (u: (builtins.substring (builtins.stringLength u - 4) 4 u) == ".nix") (listDir dir));

  generateUser =
    { name
    , username
    , email
    , groups
    , hosts
    , face
    , background
    , files ? { }
    , extraNixosConfig ? { }
    , extraHomeConfig ? { }
    , extraPackages ? [ ]
    , pkgs
    ,
    }: {
      inherit hosts;
      nixosConfig = {
        isNormalUser = true;
        description = name;
        extraGroups = [ "networkmanager" "video" "audio" ] ++ groups;
        shell = pkgs.zsh;
      } // extraNixosConfig;
      homeConfig = {
        home.username = username;
        home.homeDirectory = "/home/${username}";

        home.packages = extraPackages;

        programs.git.userName = name;
        programs.git.userEmail = email;

        home.file = {
          ".face".source = face;
        } // files;

        dconf.settings = {
          "org/gnome/desktop/background" = {
            "picture-uri" = "file://${background}";
            "picture-uri-dark" = "file://${background}";
            "color-shading-type" = "solid";
            "picture-options" = "zoom";
            "primary-color" = "#000000000000";
            "secondary-color" = "#000000000000";
          };
          "org/gnome/desktop/screensaver" = {
            "picture-uri" = "file://${background}";
            "color-shading-type" = "solid";
            "picture-options" = "zoom";
            "primary-color" = "#000000000000";
            "secondary-color" = "#000000000000";
          };
        };
      } // extraHomeConfig;
    };

  # Allows unfree packages and insecure packages to be specified as
  # `nixpkgs.allowUnfreePackages = [ "steam" "steam-original" ];`
  # `nixpkgs.permittedInsecurePackages = [ "jitsi-meet" ];`
  # Modified from code by @Majiir https://github.com/NixOS/nixpkgs/issues/197325#issuecomment-1579420085
  nixpkgsMerger = { lib, config, ... }:
    {
      options = with lib; {
        nixpkgs.allowUnfreePackages = mkOption {
          type = with types; listOf str;
          default = [ ];
          example = [ "steam" "steam-original" ];
        };
        nixpkgs.permittedInsecurePackages = mkOption {
          type = with types; listOf str;
          default = [ ];
          example = [ "jitsi-meet" ];
        };
      };

      config = {
        nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowUnfreePackages;
        nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem "${lib.getName pkg}-${lib.getVersion pkg}" config.nixpkgs.permittedInsecurePackages;
      };
    };
}
