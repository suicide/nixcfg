{lib, ...}: {
  internal.modules = {
    nixos.gc = {
      nix = {
        gc = {
          # Automatic garbage collection
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 14d";
        };

        optimise.automatic = true;
      };
    };
  };
}
