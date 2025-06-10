{ config, pkgs, inputs, vars, ... }:

{

  environment.systemPackages = with pkgs; [
    fuse
    appimage-run
  ];
  
  # These indicate the version of NixOS that my default settings are based on.
  # Be very careful when changing these, and make sure to consult any documentation first.
  system.stateVersion = "24.05";
  home-manager.users."${vars.master.name}".home = {
	stateVersion = "24.05";

	packages = with pkgs; [
      android-tools
	];
  };

  home-manager.backupFileExtension = "backup";
  
  imports = [
    ./hardware-configuration.nix
    ./lab_shares.nix
  ];

  core = {
	enable = true;
	timeZone = "America/Chicago";
  };
  
  theming.enable = true;

  drivers.audio.enable = true;
  drivers.graphics.amd.enable = true;

  suites.flatpak.enable = true;

  de.hypr = {
    enable = true;

    monitors = [
      "desc:ASUSTek COMPUTER INC VG27AQ1A R7LMQS165743, 2560x1440@144, 0x0, 1" # Primary monitor
      "desc:LG Electronics LG ULTRAGEAR 303MXPH57784, 2560x1440@144, 2560x0, 1" # Secondary monitor
      ", highrr, auto, auto" # Fallback rule
    ];
  };

  de.niri.enable = true;

  terminal.foot = {
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

  suites.git = {
	enable = true;
	name = "arcensyl";
	email = "dev@arcensyl.me";
  };

  suites.ai = {
	enable = true;
	backend = "amd";
  };

  apps.browsers.nyxt-electron = {
	enable = true;
	default = true;
  };

  apps.discord.enable = true;

  suites.media.enable = true;

  suites.gaming = {
    enable = true;

    extraGames = with pkgs; [
      #vintagestory
      starsector
      ioquake3
      urbanterror
    ];
  };

  suites.vr.enable = true;

  lang = {
	tools.enable = true;
	japanese.enable = true;
  };
}
