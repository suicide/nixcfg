{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      font.name = "NotoMono Nerd Font";
      settings = {
        enable_audio_bell = "no";
        copy_on_select = "yes";
      };
      extraConfig = ''
        # EXTRA config
        include dracula.conf
      '';
    };

    home.file."${config.home.homeDirectory}/.config/kitty/dracula.conf" = {
      source =
        pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "kitty";
          rev = "87717a3f00e3dff0fc10c93f5ff535ea4092de70";
          hash = "sha256-78PTH9wE6ktuxeIxrPp0ZgRI8ST+eZ3Ok2vW6BCIZkc=";
        }
        + "/dracula.conf";
    };

    home.packages = with pkgs; [
    ];
  };
}
