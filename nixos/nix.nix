{
  self,
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # revision
    system.configurationRevision = builtins.toString (self.shortRev or self.dirtyShortRev or "unknown");
  };
}
