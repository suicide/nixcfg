{...}: {
  internal.modules = {
    home.gtk = {
      lib,
      pkgs,
      config,
      ...
    }: let
      hyprlandCfg = config.__cfg.hyprland;
    in {
      config = {
        home.pointerCursor = lib.mkIf (!hyprlandCfg.enable) {
          enable = true;
          gtk.enable = true;
          x11.enable = true;
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 16;
        };

        gtk = {
          enable = true;

          theme = {
            package = pkgs.catppuccin-gtk.override {
              variant = "mocha";
              accents = ["mauve"];
              size = "standard";
            };
            name = "catppuccin-mocha-mauve-standard";
          };

          gtk4.theme = null;

          iconTheme = {
            package = pkgs.adwaita-icon-theme;
            name = "Adwaita";
          };

          font = {
            name = "Sans";
            size = 10;
          };
        };
      };
    };
  };
}
