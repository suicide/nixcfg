{...}: {
  internal.modules = {
    nixos.wifi = {
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    };
  };
}
