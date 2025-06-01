{ lib, pkgs, config, ... }:

{
  config = {
    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/keys/psy.txt"; # must have no password!
      defaultSopsFile = ../secrets.yaml;
      secrets."my_secret/key1" = {
        # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

        # %r gets replaced with a runtime directory, use %% to specify a '%'
        # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
        # DARWIN_USER_TEMP_DIR) on darwin.
        path = "%r/test.txt"; 
      };
    };
  };
}
