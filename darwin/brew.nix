{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  config = {
    nix-homebrew = {
      enable = true;

      enableRosetta = true;

      user = config.system.primaryUser;

      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };

      mutableTaps = false;
    };

    homebrew = {
      enable = true;

      onActivation = {
        cleanup = "uninstall";
        upgrade = true;
        autoUpdate = true;
      };

      casks = [
        "caffeine"
      ];

      brews = [];

      # passing declared taps
      # https://github.com/zhaofengli/nix-homebrew/issues/5#issuecomment-1878798641
      taps = builtins.attrNames config.nix-homebrew.taps;
    };
  };
}
