{...}: {
  internal.modules = {
    # Inactive: commented/unselected in legacy entrypoint, preserved for reference.
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
