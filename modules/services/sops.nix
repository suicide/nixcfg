{
  inputs,
  lib,
  ...
}: let
  options = {
    __cfg.sops.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SOPS secrets";
    };
  };
in {
  internal.modules = {
    nixos.sops = {
      imports = [inputs.sops-nix.nixosModules.sops];
      inherit options;
    };

    darwin.sops = {
      imports = [inputs.sops-nix.darwinModules.sops];
      inherit options;
    };

    # general home sops config, user secrets are defined in user folder
    home.sops = {
      lib,
      pkgs,
      config,
      ...
    }: let
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      cfg = config.__cfg.sops;
    in {
      options = {
        __cfg.sops.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable SOPS secrets";
        };
      };

      config = {
        sops = lib.mkIf (cfg.enable) {
          age.keyFile = keyFile; # must have no password!
        };
      };
    };
  };
}
