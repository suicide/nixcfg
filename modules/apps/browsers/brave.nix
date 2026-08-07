{...}: {
  internal.modules = {
    home.brave = {
      lib,
      pkgs,
      ...
    }: {
      config = {
        programs.brave = {
          enable = true;
          commandLineArgs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            "--password-store=gnome-libsecret"
          ];
        };
      };
    };

    # NixOS persistence is composed with the project user and Impermanence modules
    nixos.brave = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".cache/BraveSoftware"
              ".config/BraveSoftware"
            ];
          };
        };
      };
    };
  };
}
