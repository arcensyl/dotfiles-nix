{ lib, config, pkgs, vars, ... }:

let
  cfg = config.suites.vr;

in {
  options.suites.vr.enable = lib.mkEnableOption "a suite of serviced and tools for VR (Virtual Reality)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      opencomposite
    ];
    
    services.wivrn = {
      # Enables the WiVRn daemon, and tells it to run on system startup.
      enable = true;
      autoStart = true;

      # Opens TCP and UDP port 9757 so WiVRn can talk over it.
      openFirewall = true;

      defaultRuntime = true;

      config.enable = true;
      
      config.json = {
        # This is the scale of foveation scaling.
        # Foveation is an image processing technique that compresses images outside of given fixation points.
        # Essentially, this allows WiVRn to prioritize sending parts of a frame that will likely be seen first.
        scale = 1.0;

        # The bitrate used by WiVRn's stream.
        bitrate = 100000000; # 100 Mb/s

        encoders = {
          # Tells WiVRn to use VAAPI, with the H265 codec, to encode its stream.
          encoder = "vaapi";
          codec = "h265";

          # General scaling of the stream.
          width = 1.0;
          height = 1.0;
          offset_x = 0.0;
          offset_y = 0.0;
        };
      };
    };

    home-manager.users."${vars.master.name}" = {
      xdg.configFile."openvr/openvrpaths.vrpath".text = ''
  {
    "config" :
    [
      "~/.local/share/Steam/config"
    ],
    "external_drivers" : null,
    "jsonid" : "vrpathreg",
    "log" :
    [
      "~/.local/share/Steam/logs"
    ],
    "runtime" :
    [
      "${pkgs.opencomposite}/lib/opencomposite"
    ],
    "version" : 1
  }
      '';
    };
  };
}
