{ lib, config, pkgs, vars, ... }:

let
  cfg = config.de.hypr;
in {
  config.home-manager.users."${vars.master.name}" = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.general = {
      gaps_in = 10;
      gaps_out = 20;
      border_size = 2;

      "col.inactive_border" = "rgb(2F2F2F)";
      "col.active_border" = "rgb(B9B9B9)";
    };

    wayland.windowManager.hyprland.settings.decoration = {
      rounding = 10;

      #drop_shadow = true;
      #shadow_range = 4;
      #shadow_render_power = 3;
      #"col.shadow" = "rgba(1a1a1aee)";

      blur = {
        enabled = true;
        size = 8;
        passes = 1;
      };
    };

    # I have barely customized my animations, so these are basically lifted directly from Hyprland's stock config.
    wayland.windowManager.hyprland.settings.animations = {
      enabled = true;

      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    wayland.windowManager.hyprland.settings.group = {
      "col.border_inactive" = "rgb(2F2F2F)";
      "col.border_active" = "rgb(B9B9B9)";

      groupbar = {
        gradients = false;
        "col.inactive" = "rgb(2F2F2F)";
        "col.active" = "rgb(B9B9B9)";
      };
    };
  };
}
