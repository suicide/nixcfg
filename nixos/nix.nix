{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}
