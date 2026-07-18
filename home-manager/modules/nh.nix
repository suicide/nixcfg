{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.nh = {
      enable = true;
    };

    home.packages = with pkgs; [
    ];
  };
}
