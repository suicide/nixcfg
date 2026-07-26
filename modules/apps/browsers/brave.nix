{...}: {
  internal.modules = {
    home.brave = {config, ...}: {
      config = {
        programs.brave.enable = true;
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
