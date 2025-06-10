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
      home.packages = [ pkgs.hyprpaper ];

      wayland.windowManager.hyprland = {
        enable = true;
        settings.monitor = cfg.monitors;
        settings.exec-once = [ "hyprpaper" ];
      };

      home.file.hyprpaper = {
        target = ".config/hypr/hyprpaper.conf";
        text = ''
          preload = ${vars.master.dotDir}/nix/gen/current_wallpaper
          wallpaper =, ${vars.master.dotDir}/nix/gen/current_wallpaper
        '';
      };
    };
  };
}
