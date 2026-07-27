{lib, ...}: {
  internal.modules = {
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
  };
}
