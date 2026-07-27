{...}: {
  internal.modules = {
    home.gpg = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        programs.gpg = {
          enable = true;
        };

        services.gpg-agent = {
          enable = true;

          defaultCacheTtl = 7200;

          enableZshIntegration = true;

          pinentry = {
            package = pkgs.pinentry-curses;
          };
        };

        home.packages = with pkgs; [
          pinentry-curses
        ];
      };
    };

    # NixOS persistence is composed with the project user and Impermanence modules
    nixos.gpg = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              {
                directory = ".gnupg";
                mode = "0700";
              }
            ];
          };
        };
      };
    };
  };
}
