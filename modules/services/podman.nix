{...}: {
  internal.modules = {
    home.podman = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        services.podman = {
          enable = true;
        };
      };
    };
  };
}
