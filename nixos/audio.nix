{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    __cfg.audio.defaultVolume = lib.mkOption {
      type = lib.types.float;
      default = 0.1;
      description = "Default volume on default output";
    };
  };
  config = {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;

      wireplumber = {
        enable = true;

        extraConfig = let
          volume = config.__cfg.audio.defaultVolume;
          cubicVolume = volume * volume * volume;
        in {
          "01-set-default-sink-volume" = {
            "wireplumber.settings" = {
              "device.routes.default-sink-volume" = cubicVolume; # Set default output volume to 10% on cubic scale 0.1 ^ 3
            };
          };
        };
      };
    };
  };
}
