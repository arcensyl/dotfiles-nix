{ lib, config, pkgs, vars, ... }:

let
  cfg = config.suites.commands;
  beepGroup = "beep";
in {
  options.suites.commands.enable =
    lib.mkEnableOption "the suite for various command-line utilities";

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      PATH = [ "${vars.master.flakeDir}/scripts" ];
    };
    
    home-manager.users."${vars.master.name}" = {
	  home.packages = with pkgs; [
	    wl-clipboard
	    fastfetch
	    tealdeer
        beep
	  ];
	  
	  programs.zoxide.enable = true;
	  
	  programs.eza = {
	    enable = true;
	    icons = "auto";
	  };

      programs.jq.enable = true;
	  programs.fzf.enable = true;
	  programs.bat.enable = true;

      home.shellAliases = {
	    ls = "eza --oneline";
	    ll = "eza --oneline --long";
	    cd = "z";
        "with" = "nix-shell --command $SHELL -p";
	  };
    };

    # FIXME: The 'beep' command still doesn't work!
    # The 'beep' command needs extra set-up to work.
    # Essentially, we make a 'beep' group, and make our user part of it.

    users.users."${vars.master.name}".extraGroups = [ beepGroup ];

    services.udev.extraRules = ''
    # Add write access to the PC speaker for the "${beepGroup}" group
    ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="PC Speaker", ENV{DEVNAME}!="", RUN+="${pkgs.acl}/bin/setfacl -m g:${beepGroup}:w '$env{DEVNAME}'"
    '';
  };
}
