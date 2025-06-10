{ lib, config, pkgs, vars, ... }:

let
  cfg = config.de.hypr;
in {
  config = lib.mkIf cfg.enable {
    # Configures sudo to allow members of the "wheel" group to change TTYs without a password.
    # This is used for a keybind that escapes Hyprland by placing the user into TTY #3.
    security.sudo.extraRules = lib.mkAfter [{
      groups = [ "wheel" ];
      # This will not allow you to run the 'chvt' command normally accessible from your PATH.
      # I'm not sure why, but my guess is it involves sudo's 'secure_path' setting.
      commands = [{ command = "${pkgs.kbd}/bin/chvt"; options = [ "NOPASSWD" ]; }];
    }];
    
    home-manager.users."${vars.master.name}" = {
      wayland.windowManager.hyprland.settings = {
        bind = [
          # As mentioned earlier, this keybind only works when pointed at the absolute path of 'chvt'.
          "CTRL ALT, DELETE, exec, sudo ${pkgs.kbd}/bin/chvt 3}"

          "SUPER, up, movefocus, u"
          "SUPER, left, movefocus, l"
          "SUPER, down, movefocus, d"
          "SUPER, right, movefocus, r"

          "SUPER SHIFT, up, movewindow, u"
          "SUPER SHIFT, left, movewindow, l"
          "SUPER SHIFT, down, movewindow, d"
          "SUPER SHIFT, right, movewindow, r"

          "SUPER CTRL, up, movewindoworgroup, u"
          "SUPER CTRL, left, movewindoworgroup, l"
          "SUPER CTRL, down, movewindoworgroup, d"
          "SUPER CTRL, right, movewindoworgroup, r"

          "ALT, TAB, cyclenext"
          
          "SUPER, C, killactive"
          
          "SUPER, V, togglefloating"
          
          "SUPER, F, fullscreen"

          "SUPER, G, togglegroup"

          "SUPER, PAGE_UP, changegroupactive, b"
          "SUPER, PAGE_DOWN, changegroupactive, f"

          "SUPER CTRL, PAGE_UP, movegroupwindow, b"
          "SUPER CTRL, PAGE_DOWN, movegroupwindow"

          "SUPER ALT, up, swapactiveworkspaces, current u"
          "SUPER ALT, left, swapactiveworkspaces, current l"
          "SUPER ALT, down, swapactiveworkspaces, current d"
          "SUPER ALT, right, swapactiveworkspaces, current r"
        
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"
          "SUPER, 6, workspace, 6"
          "SUPER, 7, workspace, 7"
          "SUPER, 8, workspace, 8"
          "SUPER, 9, workspace, 9"
          "SUPER, 0, workspace, 10"

          "SUPER SHIFT, 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, movetoworkspace, 2"
          "SUPER SHIFT, 3, movetoworkspace, 3"
          "SUPER SHIFT, 4, movetoworkspace, 4"
          "SUPER SHIFT, 5, movetoworkspace, 5"
          "SUPER SHIFT, 6, movetoworkspace, 6"
          "SUPER SHIFT, 7, movetoworkspace, 7"
          "SUPER SHIFT, 8, movetoworkspace, 8"
          "SUPER SHIFT, 9, movetoworkspace, 9"
          "SUPER SHIFT, 0, movetoworkspace, 10"
        ];

        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];
      };
    };
  }; 
}
