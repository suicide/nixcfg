{...}: {
  internal.modules = {
    nixos.tpm = {config, ...}: let
      cfg = config.__cfg;
    in {
      config = {
        security.tpm2 = {
          enable = true;
          pkcs11.enable = true;
          tctiEnvironment.enable = true;
        };

        users.users.${cfg.mainUser} = {
          extraGroups = ["tss"];
        };
      };
    };

    home.tpm = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        home.packages = with pkgs; [
          tpm2-tools
        ];
      };
    };
  };
}
