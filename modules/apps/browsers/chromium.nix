{...}: {
  internal.modules = {
    home.chromium = {...}: {
      config = {
        programs.chromium = {
          enable = true;
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
