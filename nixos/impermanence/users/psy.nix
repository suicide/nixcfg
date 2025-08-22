{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  cfg = config.__cfg.impermanence;
in {
  config = {
    environment.persistence.${cfg.persistDir} = {
      users.psy = {
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
          ".local/share/direnv"

          ## neovim stuff
          ".local/share/nvim"
          ".vim/undodir"

          ## Brave
          ".cache/BraveSoftware"
          ".config/BraveSoftware"

          ".cache/chromium"
          ".config/chromium"

          ".mozilla"

          ".librewolf"
        ];
        files = [
          ".zsh_history"
        ];
      };
    };
  };
}

# wireplumber audio levels: .local/state/wireplumber/default-routes
