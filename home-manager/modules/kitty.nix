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
        # Do not copy mouse selections to the regular clipboard. On Linux
        # Wayland/X11 sessions, normal mouse selections still populate the
        # primary selection through the compositor/display server.
        copy_on_select = "no";

        # Let zsh url-quote-magic handle URL escaping uniformly inside and
        # outside tmux. Keep confirm for terminal control code safety.
        paste_actions = "confirm";

        auto_reload_config = "-1";
      };
      extraConfig = let
        darwinExtraConfig =
          if pkgs.stdenv.isDarwin
          then ''
            macos_option_as_alt = left
          ''
          else "";
      in
        ''
          # EXTRA config
          include dracula.conf
          symbol_map U+1FBF0-U+1FBF9 Noto Sans Symbols 2

          # Clipboard behavior on Linux Wayland/X11:
          #   copy_on_select=no             — do not copy selection → regular clipboard
          #   paste_actions=confirm         — let zsh handle URL quoting; confirm
          #                                   dangerous control codes
          #   mouse selection               — primary selection (Linux/Wayland behavior)
          #   ctrl+shift+c                  — explicit copy to regular clipboard
          #   ctrl+shift+v                  — paste from regular clipboard
          #   ctrl+shift+s                  — paste from primary selection
          # These are kitty defaults except paste_actions; listed here for
          # discoverability.
        ''
        + darwinExtraConfig;
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
