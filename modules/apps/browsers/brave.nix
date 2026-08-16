{...}: {
  internal.modules = {
    home.brave = {
      lib,
      pkgs,
      ...
    }: {
      config = {
        programs.brave = {
          enable = true;
          commandLineArgs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            "--password-store=gnome-libsecret"
          ];
        };
      };
    };

    # NixOS persistence is composed with the project user and Impermanence modules
    nixos.brave = {config, ...}: {
      config = {
        # Keep the session-only cookie default. These URLs are allowed to persist
        # independently of the Shields cookies UI / unused account_values map.
        environment.etc."brave/policies/managed/cookies.json".text = builtins.toJSON {
          CookiesAllowedForUrls = [
            "https://[*.]amazon.de"
            "https://[*.]chatgpt.com"
            "https://[*.]discord.com"
            "https://[*.]excalidraw.com"
            "https://[*.]farcaster.xyz"
            "https://[*.]feedly.com"
            "https://[*.]get-it.us"
            "https://[*.]github.com"
            "https://[*.]google.com"
            "https://[*.]grok.com"
            "https://[*.]hastybox.com"
            "https://[*.]hyperliquid.xyz"
            "https://[*.]insilicoterminal.com"
            "https://[*.]instagram.com"
            "https://[*.]perplexity.ai"
            "https://[*.]reddit.com"
            "https://[*.]telegram.org"
            "https://[*.]tradingview.com"
            "https://[*.]twitch.tv"
            "https://[*.]twitter.com"
            "https://[*.]venice.ai"
            "https://[*.]warpcast.com"
            "https://[*.]whatsapp.com"
            "https://[*.]x.com"
            "https://[*.]youtube.com"
          ];
        };

        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".cache/BraveSoftware"
              ".config/BraveSoftware"
            ];
          };
        };
      };
    };
  };
}
