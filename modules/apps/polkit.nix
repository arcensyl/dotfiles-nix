{ lib, config, pkgs, vars, ... }:
let
  cfg = config.apps.polkit;
in {
  options.apps.polkit.enable =
    lib.mkEnableOption "Polkit, a tool that allows other applications to gain elevated privileges";

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;

    home-manager.users."${vars.master.name}" = {
      wayland.windowManager.hyprland.settings.exec-once = lib.mkIf config.de.hypr.enable [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];
    };
  };
}
