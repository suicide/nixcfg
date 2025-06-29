{
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
}
