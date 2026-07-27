{...}: {
  internal.modules = {
    home.direnv = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        programs.direnv = {
          enable = true;
          enableZshIntegration = true;

          nix-direnv = {
            enable = true;
          };
        };
      };
    };

    nixos.direnv = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".local/share/direnv"
            ];
          };
        };
      };
    };
  };
}
