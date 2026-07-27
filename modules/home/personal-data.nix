{lib, ...}: {
  internal.modules = {
    nixos."home-personal-data" = {config, ...}: let
      impermanenceCfg = config.__cfg.impermanence;
      mainUser = config.__cfg.mainUser;
    in {
      config = {
        environment.persistence.${impermanenceCfg.persistDir} = {
          users.${mainUser} = {
            directories = [
              "Downloads"
              "Music"
              "Pictures"
              "Documents"
              "Videos"
              "vms"
              "projects"
              "tmp"
              ".vault"
            ];
          };
        };
      };
    };
  };
}
