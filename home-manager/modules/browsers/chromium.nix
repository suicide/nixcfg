{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.chromium = {
      enable = true;
    };
  };
}
