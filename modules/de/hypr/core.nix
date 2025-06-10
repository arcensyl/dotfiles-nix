{ lib, config, pkgs, home-manager, inputs, vars, ... }:

let
  cfg = config.de.hypr;
in {
  options.de.hypr = {
    enable =
      lib.mkEnableOption "Hyprland, as this machine's WM, along with other Hypr programs.";

    monitors = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ", highrr, auto, auto" ];
      description = "A list of monitor rules to pass to Hyprland.";
    };
  };
  
  config = lib.mkIf cfg.enable {
    de.hasEnvironment = true;

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };

    home-manager.users."${vars.master.name}" = {
      wayland.windowManager.hyprland.enable = true;

      wayland.windowManager.hyprland.settings = {
        monitor = cfg.monitors;
      };

      services.hyprpaper.enable = true;
    };
  };
}
