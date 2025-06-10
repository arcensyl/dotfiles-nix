{ lib, config, pkgs, ... }:

let
  cfg = config.drivers.audio;
in {
  options.drivers.audio = {
    enable =
      lib.mkEnableOption "audio support via the Pipewire service";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
