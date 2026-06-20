{
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
}
