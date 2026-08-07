{lib, ...}: {
  internal.modules = {
    nixos."home-credentials" = {config, ...}: let
      impermanenceCfg = config.__cfg.impermanence;
      mainUser = config.__cfg.mainUser;
    in {
      config = {
        # Unlock Login keyring at greeter auth so Brave/libsecret OSCrypt works
        # under Hyprland/UWSM (no manual gnome-keyring-daemon exec-once).
        services.gnome.gnome-keyring.enable = true;
        security.pam.services = {
          login.enableGnomeKeyring = true;
          sddm.enableGnomeKeyring = true;
        };

        environment.persistence.${impermanenceCfg.persistDir} = {
          users.${mainUser} = {
            directories = [
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
