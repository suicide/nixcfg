{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ../../nixos/base.nix
    ../../nixos/nix.nix
    # ../../nixos/gc.nix

    ../../darwin/appearance.nix
    ../../darwin/finder.nix

    ../../darwin/brew.nix

    ../../darwin/colima.nix
  ];

  config = {
    system.primaryUser = "psy";

    users.users.psy = {
      name = "psy";
      home = "/Users/psy";
      shell = pkgs.zsh;
    };

    __cfg.sops.enable = true;

    system.stateVersion = 6;
  };
}
