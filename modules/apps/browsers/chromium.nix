{...}: {
  internal.modules = {
    home.chromium = {
      lib,
      pkgs,
      ...
    }: {
      config = {
        programs.chromium = {
          enable = true;
          commandLineArgs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            "--password-store=gnome-libsecret"
          ];
        };
      };
    };

    nixos.chromium = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".cache/chromium"
              ".config/chromium"
            ];
          };
        };
      };
    };
  };
}
