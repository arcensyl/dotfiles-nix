{ lib, config, pkgs, vars, ... }:

let
  cfg = config.drivers.graphics;
in {
  options.drivers.graphics.amd.enable =
    lib.mkEnableOption "support for graphics via AMD hardware";

  config = lib.mkIf cfg.amd.enable {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = ["amdgpu"];
  };
}
