{ lib, config, pkgs, vars, ... }:

let
  cfg = config.suites.flatpak;
in {
  options.suites.flatpak.enable =
	lib.mkEnableOption "a suite of game launchers and tools";

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
