{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;

      nix-direnv = {
        enable = true;
      };
    };
  };
}
