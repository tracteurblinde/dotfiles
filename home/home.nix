{ inputs, lib, pkgs, ... }:
{
  imports = [
    ./programs/fish.nix
    ./programs/zsh.nix
  ];

  # Allow _some_ unfree packages
  nixpkgs.allowUnfreePackages = [
  ];

  # Acknowledge insecure packages
  nixpkgs.config.permittedInsecurePackages = [
  ];

  home.packages = with pkgs; [
    eza
    neovim
    tmux
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    PATH = "$HOME/.config/zsh/scripts:$HOME/.cargo/bin:$PATH";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
    };
  };

  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
}
