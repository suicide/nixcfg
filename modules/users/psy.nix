{
  lib,
  config,
  ...
}: let
  flakePartsConfig = config;
in {
  internal.modules = {
    nixos.psy = {
      config,
      pkgs,
      hostname,
      ...
    }: let
      nixosCfg = config;
      cfg = nixosCfg.__cfg;
    in {
      imports = [
        flakePartsConfig.internal.modules.nixos."home-personal-data"
        flakePartsConfig.internal.modules.nixos."home-credentials"
        flakePartsConfig.internal.modules.nixos.brave
      ];
      options.__cfg.mainUser = lib.mkOption {
        type = lib.types.str;
        default = "psy";
        description = "Main user to provision";
      };

      config = {
        users.users.${cfg.mainUser} = {
          isNormalUser = true;
          uid = 1000;
          description = cfg.mainUser;
          hashedPassword = "$6$Y147CW7B3CWybgq7$VDfH7eOp4YaYLAP6QWAX.KEZ2YYwzoFkzvOLpzMUifFZBwluIBtmjdf7hHLBbyRsg.c6WT5qMTTITit2pc2Xt/";
          extraGroups = ["networkmanager" "wheel"];
          shell = pkgs.zsh;
        };

        home-manager.users.${cfg.mainUser}.imports = [
          ../../home-manager/home.nix
          ../../home-manager/users/${cfg.mainUser}
          ../../hosts/${hostname}/home.nix
          flakePartsConfig.internal.modules.home.sops
          flakePartsConfig.internal.modules.home.brave
        ];
      };
    };

    darwin.psy = {
      config,
      hostname,
      ...
    }: {
      home-manager.users.${config.system.primaryUser}.imports = [
        ../../home-manager/home-darwin.nix
        ../../hosts/${hostname}/home.nix
        flakePartsConfig.internal.modules.home.sops
        flakePartsConfig.internal.modules.home.brave
      ];
    };
  };
}
