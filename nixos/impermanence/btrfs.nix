{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  config = {
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly"; # or "weekly"
      fileSystems = ["/"]; # avoid re-scrubbing data multiple times
    };
  };
}
