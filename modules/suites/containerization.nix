{ lib, config, pkgs, vars, ... }:

let
  cfg = config.suites.containerization;
in {
  options.suites.containerization = {
    enable =
      lib.mkEnableOption "support for containers powered by Podman";

    distrobox.enable =
      lib.mkEnableOption "Distrobox, for creating containers, running nearly any Linux distribution, that are heavily integrated with your host";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.systemPackages = lib.filter (v: v != null) [
      (if cfg.distrobox.enable then pkgs.distrobox else null)
    ];
  };
}
