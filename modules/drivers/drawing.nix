{ lib, config, pkgs, ... }:

let
  cfg = config.drivers.drawing;
in {
  options.drivers.drawing.enable =
    lib.mkEnableOption "the driver for drawing tablets";

  config = lib.mkIf cfg.enable  {
    hardware.opentabletdriver.enable = true;
  };
}
