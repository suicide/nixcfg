{
  lib,
  pkgs,
  config,
  ...
}: let
  awesomeConf = pkgs.fetchFromGitHub {
    owner = "suicide";
    repo = "dots_moi";
    rev = "ac9b5ec6e92041bf8ee38986d148651603e7b5d7";
    hash = "sha256-J4oqnKO45hgbYWUa8F4YtMiYm5NkGAb6DnYpIM5jq7g=";
  };
in {
  config = {
    xsession.windowManager.awesome = {
      enable = true;
    };

    ## old config
    home.file."${config.home.homeDirectory}/.config/awesome/rc.lua" = {
      source = ./rc.lua;
    };
    home.file."${config.home.homeDirectory}/.config/awesome/themes" = {
      source = awesomeConf + "/dot_config/awesome/themes";
    };

    home.file."${config.home.homeDirectory}/.config/awesome/freedesktop" = {
      source = pkgs.fetchFromGitHub {
        owner = "lcpz";
        repo = "awesome-freedesktop";
        rev = "c82ad2960c5f0c84e765df68554c266ea7e9464d";
        hash = "sha256-lQstCcTPUYUt5hzAJIyQ16crPngeOnUla7I4QiG6gEs=";
      };
    };
    home.file."${config.home.homeDirectory}/.config/awesome/lain" = {
      source = pkgs.fetchFromGitHub {
        owner = "lcpz";
        repo = "lain";
        rev = "88f5a8abd2649b348ffec433a24a263b37f122c0";
        hash = "sha256-MH/aiYfcO3lrcuNbnIu4QHqPq25LwzTprOhEJUJBJ7I=";
      };
    };
  };
}
