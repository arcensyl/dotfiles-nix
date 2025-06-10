{ lib, config, pkgs, inputs, vars, ... }:

let
  cfg = config.suites.media;
in {
  options.suites.media.enable =
    lib.mkEnableOption "the suite for music and video playback";

  config.home-manager.users."${vars.master.name}" = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl
      rmpc
      ani-cli
      inputs.curd.packages.${pkgs.system}.default
    ];

    # Music Player Daemon (MPD) is a server that plays and manages music.
    # As MPD is just a back-end, it needs to be controlled by a client.
    services.mpd = {
      enable = true;
      musicDirectory = "${vars.master.homeDir}/Music";
      playlistDirectory = "${vars.master.homeDir}/Music/Playlists";
      dataDir = "${vars.master.homeDir}/.util/mpd";

      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Primary Output"
        }
      '';
    };

    # This addon for MPD allows it be controlled through MPRIS.
    services.mpd-mpris.enable = true;

    programs.ncmpcpp = {
      enable = true;
      mpdMusicDir = "${vars.master.homeDir}/Music";

      settings = {
        media_library_primary_tag = "album_artist";
      };
    };
    
    programs.yt-dlp.enable = true;

    programs.mpv.enable = true;
  };
}
