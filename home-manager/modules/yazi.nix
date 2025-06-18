{ lib, pkgs, config, ... }:

{
  config = {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        mgr = {
          show_hidden = true;
        };
      };
    };

    home.packages = with pkgs; [ 
    ];
  };
}


