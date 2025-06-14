{ lib, config, pkgs, vars, ... }:

let
  cfg = config.apps.discord;
in {
  options.apps.discord.enable =
    lib.mkEnableOption "Discord, or one of its alternate clients";

  config.home-manager.users."${vars.master.name}" = lib.mkIf cfg.enable {
    programs.vesktop.enable = true;

    wayland.windowManager.hyprland.settings.bind = lib.mkIf config.de.hypr.enable [
      "CTRL ALT, C, exec, vesktop"
    ];
  };
}
