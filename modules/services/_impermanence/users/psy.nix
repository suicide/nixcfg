{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  cfg = config.__cfg.impermanence;
in {
  config = {
    environment.persistence.${cfg.persistDir} = {
      users.psy = {
        directories = [
          # Uncomment after validating the combined PipeWire sink setup on
          # psy-work1 so WirePlumber can remember the default sink and routes.
          # ".local/state/wireplumber"
        ];
      };
    };
  };
}
