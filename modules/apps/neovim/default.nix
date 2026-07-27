{lib, ...}: {
  internal.modules = {
    home.neovim = {
      config,
      pkgs,
      inputs,
      ...
    }: {
      imports = [
        ./_neovim.nix
      ];
    };

    # Linux-only mcphub module, separately selectable.
    # Requires `home.neovim` to be composed alongside it since the latter
    # declares the `__cfg.neovim` options consumed here.
    home.neovim-mcphub = {
      lib,
      pkgs,
      config,
      inputs,
      ...
    }: {
      imports = [
        ./_mcphub.nix
      ];
    };

    nixos.neovim = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".local/share/nvim"
              ".vim/undodir"
              ".config/github-copilot" # copilot.vim auth
            ];
          };
        };
      };
    };
  };
}
