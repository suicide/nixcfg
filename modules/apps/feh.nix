{...}: {
  internal.modules = {
    home.feh = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        programs.feh = {
          enable = true;
        };

        xdg.mimeApps = {
          defaultApplications = let
            feh = "feh.desktop";
            types = ["image/png" "image/jpeg" "image/gif" "image/webp" "image/bmp"];
          in
            lib.genAttrs types (t: feh);
        };
      };
    };
  };
}
