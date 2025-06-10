{ lib, config, pkgs, inputs, vars, ... }:

let
  cfg = config.terminal.wezterm;
in {
  options.terminal.wezterm = {
    enable =
      lib.mkEnableOption "the terminal emulator Wezterm";

    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Determines if Wezterm should be this machine's default terminal emulator.";
    };
  };

  config.home-manager.users."${vars.master.name}" = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
    };

    programs.wezterm.extraConfig = ''
      return {
        front_end = "WebGpu",
        --enable_wayland = false,

        window_background_opacity = 0.8,
        hide_tab_bar_if_only_one_tab = true,
      }
    '';

    wayland.windowManager.hyprland.settings.bind = lib.mkIf (cfg.default && config.de.hypr.enable) [
      "SUPER, Q, exec, wezterm"
    ];
  };
}
