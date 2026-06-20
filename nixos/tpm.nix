{
  config,
  pkgs,
  inputs,
  ...
}: let
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
}
