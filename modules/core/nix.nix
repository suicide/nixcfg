{lib, ...}: {
  internal.modules = {
    nixos.nix = {
      nix.settings.experimental-features = ["nix-command" "flakes"];

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Temporary: keep the system derivation stable while comparing the dendritic refactor.
      system.configurationRevision = lib.mkForce "refactor-comparison";
    };

    darwin.nix = {
      nix.settings.experimental-features = ["nix-command" "flakes"];

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;
    };
  };
}
