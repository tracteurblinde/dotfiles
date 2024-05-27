{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    blender
  ];


  # Talon wants to be able to write to this directory :/
  #   home.file.".talon/user/community" = {
  #     source = pkgs.fetchFromGitHub
  #       {
  #         owner = "talonhub";
  #         repo = "community";
  #         rev = "fce77d0a1a3825cc77ea91b487b4276024ec475f";
  #         hash = "sha256-3YiaZsE/iuuQ1DkmTPK6KBdzLbpw7g81EMNcgcvf+yM=";
  #       };
  #   };
}
