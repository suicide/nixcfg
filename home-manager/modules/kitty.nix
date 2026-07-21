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
      settings =
        {
          enable_audio_bell = "no";
          # Clipboard behavior:
          #   Linux: keep mouse selections in primary selection only (not regular
          #   clipboard). The compositor/display server handles that without kitty.
          #   macOS: no primary selection exists, so mouse selection copies to the
          #   system pasteboard (the only clipboard target available).
          copy_on_select =
            if pkgs.stdenv.isDarwin
            then "yes"
            else "no";

          # Let zsh url-quote-magic handle URL escaping uniformly inside and
          # outside tmux. Keep confirm for terminal control code safety.
          paste_actions = "confirm";

          auto_reload_config = "-1";
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          # On macOS, tmux OSC 52 clipboard writes should flow through kitty to
          # the system pasteboard while clipboard reads still require consent.
          clipboard_control = "write-clipboard read-clipboard-ask";
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

          # Clipboard behavior:
          #   Linux/Wayland: mouse selection populates primary selection;
          #   tmux writes primary explicitly via wl-clipboard.
          #   macOS: tmux uses OSC 52; kitty writes to the system pasteboard.
          #   copy_on_select=no             — do not copy selection → regular clipboard
          #   paste_actions=confirm         — let zsh handle URL quoting; confirm
          #                                   dangerous control codes
          #   ctrl+shift+c                  — explicit copy to regular clipboard
          #   ctrl+shift+v                  — paste from regular clipboard
          #   ctrl+shift+s                  — paste from primary selection on Linux
          # These are kitty defaults except paste_actions and Darwin
          # clipboard_control; listed here for discoverability.
        ''
        + darwinExtraConfig;
    };

    programs.zsh.shellAliases = {
      "kssh" = "kitten ssh";
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
