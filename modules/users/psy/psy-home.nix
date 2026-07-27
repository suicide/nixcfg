{lib, ...}: {
  internal.modules = {
    # NixOS / Linux user profile
    home.psy = {
      lib,
      pkgs,
      config,
      inputs,
      ...
    }: {
      imports = [
        ./_sops.nix
        ./_ssh.nix
        ./_opencode.nix
      ];

      config = {
        home = {
          username = lib.mkDefault "psy";
          homeDirectory = lib.mkDefault "/home/psy";
        };
      };
    };

    # macOS user profile (Darwin-only overrides)
    home."psy-mac" = {
      lib,
      pkgs,
      config,
      ...
    }: {
      imports = [
        ./_sops-darwin.nix
      ];
    };
  };
}
