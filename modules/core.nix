{ lib, config, pkgs, vars, ... }:

let
  cfg = config.core;
in {
  options.core = {
	enable = lib.mkEnableOption "basic programs and services for this machine";

	locale = lib.mkOption {
	  type = lib.types.str;
	  default = "en_US.UTF-8";
	  description = "The locale to use for rendering text or displaying certain region-specific information.";
	};

	keyboard.layout = lib.mkOption {
	  type = lib.types.str;
	  default = "us";
	  description = "The keyboard layout this machine uses.";
	};

	timeZone = lib.mkOption {
	  type = lib.types.str;
	  default = "UTC";
	  description = "The time zone this machine is located within.";
	};
  };

  config = lib.mkIf cfg.enable {
	networking.hostName = vars.system.name;

    # This variable is needed for future builds of my configuration.
    environment.sessionVariables.MY_HOSTNAME = vars.system.name;
    
	# The boot loader is configured here.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# This section is for any network settings.
	networking.networkmanager.enable = true;

	# Allows installation of all packages, even those with a proprietary license.
	nixpkgs.config.allowUnfree = true;

	# Enables several experimental features for Nix. Here's a list:
	#   1. nix-command - Enables several subcommands under 'nix'.
	#   2. flakes - Enables flakes, which are special Nix files that can access other flakes.
	#   3. pipe-operators - Enables pipe operators ( |> or <| ) in Nix code.
	nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];

	# Adds a variety of helpers and utilities for use with Nix.
	# TODO: Consider merging the 'suites.nix' module with this one.
	suites.nix = {
      enable = true;
      configFlake = vars.master.flakeDir;
	};

	# We set our locale for any relevant settings here.
	# This is needed so the machine knows how to properly render text.
	# These settings are also used to determine any region-specific formats, such as dates or currencies.
	i18n.defaultLocale = cfg.locale;
	
	i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.locale;
      LC_IDENTIFICATION = cfg.locale;
      LC_MEASUREMENT = cfg.locale;
      LC_MONETARY = cfg.locale;
      LC_NAME = cfg.locale;
      LC_NUMERIC = cfg.locale;
      LC_PAPER = cfg.locale;
      LC_TELEPHONE = cfg.locale;
      LC_TIME = cfg.locale;
	};

	# This section tells Xorg about our machine's keyboard.
	# I have no idea if these settings do anything for Wayland, but they are here just in case.
	services.xserver.xkb = {
	  layout = cfg.keyboard.layout;
	  variant = "";
	};

	# The final region-related setting is our machine's time zone.
	time.timeZone = cfg.timeZone;

	# Creates this machine's main, or master, user.
	users.users."${vars.master.name}" = {
      isNormalUser = true;
      description = "${vars.master.fullName}";
      extraGroups = [ "networkmanager" "wheel" ];
	};

	# Here's any basic settings for the master user.
    home-manager.users."${vars.master.name}" = {
	  # First, we need to tell Home Manager to manage itself.
	  programs.home-manager.enable = true;

	  # Second, we need to tell Home Manager about this user.
	  home.username = vars.master.name;
	  home.homeDirectory = vars.master.homeDir;

      # Third, we include any packages helpful with general system management.
      # We only include Just for this currently.
      home.packages = [ pkgs.just ];

	  # Finally, we enable this to help when changing fonts.
      fonts.fontconfig.enable = true;
    };
  };
}
