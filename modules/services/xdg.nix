{...}: {
  internal.modules = {
    home.xdg = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        xdg.mimeApps = {
          enable = true;
          defaultApplications = {};
        };
      };
    };
  };
}
