{ lib, config, pkgs, vars, ... }:

let
  cfg = config.suites.secrets;
in {
  options.suites.secrets.enable =
    lib.mkEnableOption "tools and services for managing secrets, such as passwords or encryption keys";

  config = lib.mkIf cfg.enable {
    services.dbus.packages = [ pkgs.gcr ];

    home-manager.users."${vars.master.name}" = {
      programs.gpg.enable = true;
      
      services.gpg-agent = {
        enable = true;
        enableSshSupport = false;
        pinentryPackage = pkgs.pinentry-gnome3;
      };

      services.ssh-agent.enable = true;

      home.sessionVariables."SSH_ASKPASS" = "${pkgs.seahorse}/bin/seahorse";
      
      programs.password-store.enable = true;
    };
  };
}
