{...}: {
  internal.modules = {
    # Persistence only — this module does not install or configure gh.
    nixos.github-cli = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            files = [
              ".config/gh/hosts.yml" # github cli authentication
            ];
          };
        };
      };
    };
  };
}
