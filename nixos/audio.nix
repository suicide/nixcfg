{
  config,
  pkgs,
  inputs,
  ...
}: {
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

        extraConfig = {
          "01-set-default-sink-volume" = {
            "wireplumber.settings" = {
              "device.routes.default-sink-volume" = 0.001;  # Set default output volume to 10% on cubic scale 0.0 ^ 3
            };
          };
        };
      };
    };
  };
}
