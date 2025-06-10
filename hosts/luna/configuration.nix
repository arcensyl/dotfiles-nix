{ config, pkgs, inputs, vars, ... }:

{
  # Determines the NixOS version that default settings were derived from.
  # This should probably left as the initial version 
  system.stateVersion = "24.05";
  
  imports = [
    ./hardware-configuration.nix
    ./lab_shares.nix
  ];


  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-wrapped-7.0.20"
  ];

  networking.hostName = vars.system.name;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enables several experimental features for Nix. Here's a list:
  #   1. nix-command - Enables several subcommands under 'nix'
  #   2. flakes - Enables flakes, which are special Nix files that can access other flakes.
  #   3. pipe-operators - Enables pipe operators ( |> or <| ) in Nix code
  nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];

  nixpkgs.config.allowUnfree = true;

  suites.nix = {
    enable = true;
    configFlake = vars.master.flakeDir;
  };

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users."${vars.master.name}" = {
    isNormalUser = true;
    description = "${vars.master.fullName}";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users."${vars.master.name}" = {
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";

    home.username = vars.master.name;
    home.homeDirectory = vars.master.homeDir;

    programs.git = {
      enable = true;
      userName = vars.git.name;
      userEmail = vars.git.email;

	  extraConfig = {
		init.defaultBranch = vars.git.defaultBranch;
	  };
    };

    fonts.fontconfig.enable = true;
  };

  theming.enable = true;

  drivers.audio.enable = true;

  suites.flatpak.enable = true;

  de.hypr = {
    enable = true;

    monitors = [
      ", highrr, auto, auto" # Fallback rule
    ];
  };

  terminal.wezterm = {
    enable = true;
    default = true;
  };

  terminal.shells.zsh = {
    enable = true;
    default = true;
  };

  suites.commands.enable = true;

  suites.secrets.enable = true;
  apps.polkit.enable = true;
  
  apps.editors.nvim.enable = true;

  apps.editors.emacs = {
    enable = true;
    daemon.enable = true;
  };

  apps.browsers = {
	zen.enable = true;

	nyxt = {
	  enable = true;
	  default = true;
	};
  };

  apps.discord.enable = true;

  suites.media.enable = true;
}
