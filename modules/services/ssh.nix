{...}: {
  internal.modules = {
    home.ssh = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;

          settings."*" = {
            ForwardAgent = false;
            ServerAliveInterval = 0;
            ServerAliveCountMax = 3;
            Compression = false;
            AddKeysToAgent = "no";
            HashKnownHosts = "no";
            UserKnownHostsFile = "~/.ssh/known_hosts";
            ControlMaster = "no";
            ControlPath = "~/.ssh/master-%r@%n:%p";
            ControlPersist = "no";
          };
        };
      };
    };

    # NixOS persistence is composed with the project user and Impermanence modules
    nixos.ssh = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              {
                directory = ".ssh";
                mode = "0700";
              }
            ];
          };
        };
      };
    };
  };
}
