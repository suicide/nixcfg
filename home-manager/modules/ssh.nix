{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.ssh = {
      enable = true;
    };
  };
}
