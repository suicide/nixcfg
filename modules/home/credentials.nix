{lib, ...}: {
  internal.modules = {
    nixos."home-credentials" = {config, ...}: let
      impermanenceCfg = config.__cfg.impermanence;
      mainUser = config.__cfg.mainUser;
    in {
      config = {
        environment.persistence.${impermanenceCfg.persistDir} = {
          users.${mainUser} = {
            directories = [
              {
                directory = ".gnupg";
                mode = "0700";
              }
              {
                directory = ".ssh";
                mode = "0700";
              }
              {
                directory = ".nixops";
                mode = "0700";
              }
              {
                directory = ".local/share/keyrings";
                mode = "0700";
              }
              {
                directory = ".config/sops";
                mode = "0700";
              }
            ];
            files = [];
          };
        };
      };
    };
  };
}
