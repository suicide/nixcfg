{ lib, pkgs, config, ... }:

{
  config = {
    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;

      defaultCacheTtl = 7200;

      enableZshIntegration = true;
    };
  };
}
