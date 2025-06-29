{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.brave = {
      enable = true;
    };
  };
}
