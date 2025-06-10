{ lib, config, pkgs, vars, ... }:

let
  cfg = config.lang.tools;
in {
  options.lang.tools = {
	enable = lib.mkEnableOption "tools for working with text and multiple languages";

	extraDicts = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
      example = [ pkgs.dictdDBs.wiktionary ];
      description = "A list of extra dictionaries to install for use with dictd.";
    };
  };

  config = lib.mkIf cfg.enable {
	home-manager.users."${vars.master.name}" = {
	  wayland.windowManager.hyprland.settings = lib.mkIf config.de.hypr.enable {
		windowrule = [ "pseudo, class:fcitx" ];
		exec-once = [
		  "fcitx5 -d -r"
		  "fcitx5-remote -r"
		];
	  };
	};

	environment.systemPackages = with pkgs; [
	  dict
	];
	
	i18n.inputMethod = {
	  type = "fcitx5";
	  enable = true;
	  fcitx5.addons = [ pkgs.fcitx5-gtk ];
	};

	services.dictd = {
	  enable = true;
	  DBs = cfg.extraDicts;
	};
  };
}
