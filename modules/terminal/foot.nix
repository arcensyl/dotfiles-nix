{ lib, config, pkgs, inputs, vars, ... }:

let
  cfg = config.terminal.foot;
in {
  options.terminal.foot = {
    enable =
      lib.mkEnableOption "the terminal emulator Foot";

    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Determines if Foot should be this machine's default terminal emulator.";
    };
  };

  config.home-manager.users."${vars.master.name}" = lib.mkIf cfg.enable {
    programs.foot = {
	  enable = true;

	  settings.colors.alpha = lib.mkForce 0.8;
	};

    wayland.windowManager.hyprland.settings.bind = lib.mkIf (cfg.default && config.de.hypr.enable) [
      "SUPER, Q, exec, foot"
    ];

    # Foot looses opacity when fullscreened, so this window rule is a band-aid fix.
    # This rule ensures that Foot will only use fake fullscreen.
    # While the window geometry will change, the client itself will not be informed it is fullscreened.
    wayland.windowManager.hyprland.settings.windowrule = lib.mkIf config.de.hypr.enable [
      "fullscreenstate 3 0, class:foot, fullscreen:1"
    ];
  };
}
