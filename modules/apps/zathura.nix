{...}: {
  internal.modules = {
    home.zathura = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        programs.zathura = {
          enable = true;
        };

        xdg.mimeApps = {
          defaultApplications = {
            "application/pdf" = "org.pwmt.zathura.desktop";
          };
        };
      };
    };
  };
}
