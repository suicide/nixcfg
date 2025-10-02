{
  lib,
  pkgs,
  config,
  ...
}: let
  opacity = "E5";
  base = "#1a1b26";
  foreground = "#a9b1d6";
  red = "#f7768e";
  blue = "#7aa2f7";
  magenta = "#bb9af7";
in {
  options = {
  };

  config = {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          browser = "brave -new-tab";
          corner_radius = 8;
          dmenu = "rofi -p dunst:";
          enable_recursive_icon_lookup = true;
          ellipsize = "end";
          follow = "mouse";
          font = "NotoSans 12";
          # frame_color = "{{background}}";
          frame_width = 0;
          horizontal_padding = 10;
          # icon_theme = config.gtk.iconTheme.name;
          # icon_path = mkForce "";
          max_icon_size = 72;
          mouse_left_click = "do_action";
          mouse_middle_click = "do_action";
          mouse_right_click = "close_current";
          # separator_color = "{{color7}}";
          separator_height = 1;
          show_indicators = "no";
        };

        # Base:        #1a1b26 (Editor Background)
        # Foreground:  #a9b1d6 (Editor Foreground)
        # Blue:        #7aa2f7 (Function Names / Terminal Blue)
        # Cyan:        #7dcfff (Object Properties / Terminal Cyan)
        # Magenta:     #bb9af7 (Control Keywords / Terminal Magenta)
        # Red:         #f7768e (Terminal Red)
        # Green:       #9ece6a (Strings / Terminal Green)
        # Yellow:      #e0af68 (Terminal Yellow)

        urgency_critical = {
          background = "${base}";
          foreground = "${red}";
          frame_color = "${red}";
          timeout = 0;
        };

        urgency_low = {
          background = "${base}${opacity}";
          foreground = "${foreground}";
          frame_color = "${blue}";
          timeout = 10;
        };

        urgency_normal = {
          background = "${base}${opacity}";
          foreground = "${magenta}";
          frame_color = "${blue}";
          timeout = 10;
        };
      };
    };
  };
}
