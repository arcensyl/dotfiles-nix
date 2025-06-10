{ lib, config, pkgs, vars, ... }:

let
  cfg = config.suites.commands;
in {
  options.suites.commands.enable =
    lib.mkEnableOption "the suite for various command-line utilities";

  config.home-manager.users."${vars.master.name}" = lib.mkIf cfg.enable {
	home.packages = with pkgs; [
	  wl-clipboard
	  fastfetch
	  tealdeer
	];
	
	programs.zoxide.enable = true;
	
	programs.eza = {
	  enable = true;
	  icons = "auto";
	};

	programs.fzf.enable = true;
	programs.bat.enable = true;

	home.shellAliases = {
	  ls = "eza --oneline";
	  ll = "eza --oneline --long";
	  cd = "z";
	};
  };
}
