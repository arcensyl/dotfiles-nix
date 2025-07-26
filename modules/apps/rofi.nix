{ lib, config, pkgs, inputs, vars, ... }:

let
  cfg = config.apps.rofi;
in {

  options.apps.rofi.enable =
    lib.mkEnableOption "Rofi, the application launcher (+ extras)";
  
  
  config.home-manager.users."${vars.master.name}" = {
    home.packages = with pkgs; [
      inputs.kaokao.packages.${pkgs.system}.default
    ];

    programs.rofi.enable = true;
    
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, SPACE, exec, rofi -show drun"
        "SUPER, COMMA, exec, kaokao | wl-copy"
      ];
    };
  };
}
