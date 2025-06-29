{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    # to enable hibernate from a swapfile on btrfs
    # see https://github.com/nix-community/disko/issues/651
    boot.initrd.systemd.enable = true;

    boot.loader.systemd-boot.configurationLimit = 20;
  };
}
