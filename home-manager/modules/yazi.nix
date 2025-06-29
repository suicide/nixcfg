{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        mgr = {
          show_hidden = true;
          linemode = "size";
        };
      };
    };

    home.packages = with pkgs; [
    ];
  };
}
