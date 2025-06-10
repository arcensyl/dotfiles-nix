{ pkgs, vars, ... }:

let
  mountDir = "${vars.master.homeDir}/.util/umnt";
in{
  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems."${mountDir}/lab/data" = {
    device = "//192.168.1.201/data";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=${vars.master.dotDir}/secrets/lab_vault,uid=1000,gid=100"];
  };
  
  fileSystems."${mountDir}/lab/docker" = {
    device = "//192.168.1.201/docker";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=${vars.master.dotDir}/secrets/lab_vault,uid=1000,gid=100"];
  };
}
