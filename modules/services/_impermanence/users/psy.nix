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
          ".config/github-copilot" # copilot auth
          ".config/.copilot" # copilot-cli
          ".local/share/opencode" # opencode (auth in `auth.json`)
          ".gemini" # gemini-cli auth

          ## Brave
          ".cache/BraveSoftware"
          ".config/BraveSoftware"

          ".cache/chromium"
          ".config/chromium"

          ".config/mozilla"

          ".librewolf"

          ".electrum" # legacy
          ".bitmonero"
          ".monero"

          # Uncomment after validating the combined PipeWire sink setup on
          # psy-work1 so WirePlumber can remember the default sink and routes.
          # ".local/state/wireplumber"
        ];
        files = [
          ".zsh_history"

          ".config/gh/hosts.yml" # github cli authentication
        ];
      };
    };
  };
}
