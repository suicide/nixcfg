{ lib, pkgs, config, ... }:

{
  config = {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    home.packages = with pkgs; [ 
    ];
  };
}


