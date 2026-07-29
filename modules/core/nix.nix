{...}: {
  internal.modules = {
    nixos.nix = {self, ...}: {
      nix.settings.experimental-features = ["nix-command" "flakes"];

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      system.configurationRevision =
        builtins.toString
        (self.shortRev or self.dirtyShortRev or "unknown");
    };

    darwin.nix = {self, ...}: {
      nix.settings.experimental-features = ["nix-command" "flakes"];

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      system.configurationRevision =
        builtins.toString
        (self.shortRev or self.dirtyShortRev or "unknown");
    };
  };
}
