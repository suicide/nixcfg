{lib, ...}: {
  internal.modules = {
    nixos.boot = {
      # wait indefinitely for the resume device during hibernation resume,
      # so entering the luks passphrase cannot abort the resume and lose the
      # hibernated session (systemd aborts resume after 2 minutes otherwise)
      boot.kernelParams = ["resumeflags=x-systemd.device-timeout=infinity"];

      boot.loader.systemd-boot.configurationLimit = 20;
    };
  };
}
