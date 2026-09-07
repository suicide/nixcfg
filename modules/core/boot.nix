{lib, ...}: {
  internal.modules = {
    nixos.boot = {
      # to enable hibernate from a swapfile on btrfs
      # see https://github.com/nix-community/disko/issues/651
      boot.initrd.systemd.enable = true;

      # wait indefinitely for the resume device during hibernation resume,
      # so entering the luks passphrase cannot abort the resume and lose the
      # hibernated session (systemd aborts resume after 2 minutes otherwise)
      boot.kernelParams = ["resumeflags=x-systemd.device-timeout=infinity"];

      boot.loader.systemd-boot.configurationLimit = 20;
    };
  };
}
