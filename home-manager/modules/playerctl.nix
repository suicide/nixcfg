{
  lib,
  pkgs,
  config,
  ...
}: let
in {
  config = {
    # monitors compatible players
    services.playerctld = {
      enable = true;
    };
  };
}
