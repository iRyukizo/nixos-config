{ pkgs, ... }:

let
  faba-path = "${pkgs.faba-icon-theme}/share/icons/Faba";
  gnome-path = "${pkgs.gnome-icon-theme}/share/icons/gnome";
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        geometry = "380x20-13+51";
        corner_radius = 10;
        indicate_hidden = "yes";
        shrink = "no";
        transparancy = 0;
        notification_height = 0;
        separator_height = 2;
        padding = 12;
        horizontal_padding = 12;
        frame_width = 3;
        frame_color = "#aaaaaa";
        separator_color = "frame";
        sort = "yes";
        idle_threshhold = 120;
        line_height = 0;
        font = "SanFranciscoDisplay Nerd Font 10";
        icon_path = "${faba-path}/48x48/notifications/:${faba-path}/24x24/panel/:${faba-path}/16x16/status/:${faba-path}/symbolic/status/:${faba-path}/16x16/devices/:${faba-path}/16x16/mimetypes/:${faba-path}/16x16/notifications/:${faba-path}/16x16/emblems:${gnome-path}/16x16/status/:${gnome-path}/16x16/devices/";
        sticky_history = "yes";
        history_length = 20;
        dmenu = "rofi -show run";
        browser = "firefox";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        startup_notification = false;
        verbosity = "mesg";
        ignore_dbusclose = false;
        force_xinemara = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      shortcut = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };

      urgency_low = {
        background = "#2f343f";
        foreground = "#a3be8c";
        frame_color = "#a3be8c";
        timeout = 10;
      };

      urgency_normal = {
        background = "#2f343f";
        foreground = "#ffffff";
        frame_color = "#bfdce8";
        timeout = 5;
      };

      urgency_critical = {
        background = "#812f29";
        foreground = "#ffffff";
        frame_color = "#bf616a";
        timeout = 0;
      };
    };
  };
}
