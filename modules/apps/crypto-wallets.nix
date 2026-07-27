{...}: {
  internal.modules = {
    nixos."crypto-wallets" = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".electrum"
              ".bitmonero"
              ".monero"
            ];
          };
        };
      };
    };
  };
}
