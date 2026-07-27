{...}: {
  internal.modules = {
    home.nh = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        programs.nh = {
          enable = true;
        };
      };
    };
  };
}
