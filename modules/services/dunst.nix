{...}: let
  opacity = "E5";
  base = "#1a1b26";
  foreground = "#a9b1d6";
  red = "#f7768e";
  blue = "#7aa2f7";
  magenta = "#bb9af7";
in {
  internal.modules = {
    home.dunst = {
      lib,
      pkgs,
      config,
      ...
    }: {
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
              frame_width = 0;
              horizontal_padding = 10;
              max_icon_size = 72;
              mouse_left_click = "do_action";
              mouse_middle_click = "do_action";
              mouse_right_click = "close_current";
              separator_height = 1;
              show_indicators = "no";
            };

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
    };
  };
}
