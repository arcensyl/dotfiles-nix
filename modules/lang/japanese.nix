{ lib, config, pkgs, vars, ... }:

let
  cfg = config.lang.japanese;
in {
  options.lang.japanese.enable =
    lib.mkEnableOption "support for Japanese as a secondary language";

  config = lib.mkIf cfg.enable {
	home-manager.users."${vars.master.name}" = {
      home.packages = with pkgs; [
		ibus-engines.mozc
		kakasi
        noto-fonts-cjk-sans
        anki-bin # TODO: Move this to somewhere more logical.
	  ];
	};

    # environment.systemPackages = with pkgs; [
    #   noto-fonts-cjk-sans
    #   notonoto
    # ];
    
	i18n.inputMethod.fcitx5.addons = lib.mkIf config.lang.tools.enable [ pkgs.fcitx5-mozc ];
	services.dictd.DBs = lib.mkIf config.lang.tools.enable [ pkgs.dictdDBs.jpn2eng ];
  };
}
