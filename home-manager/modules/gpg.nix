{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;

      defaultCacheTtl = 7200;

      enableZshIntegration = true;

      pinentry = {
        package = pkgs.pinentry-curses;
      };
    };

    home.packages = with pkgs; [
      # pinentry-tty
      pinentry-curses
      # pinentry-gnome3
      # gcr
    ];
  };
}
