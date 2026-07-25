{
  inputs,
  lib,
  ...
}: {
  options.internal.modules = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.deferredModule);
    default = {};
    description = "Reusable NixOS and nix-darwin modules.";
  };

  config = {
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

    perSystem = {pkgs, ...}: {
      formatter = pkgs.alejandra;

      packages.openagents-opencode = pkgs.callPackage ../../packages/openagents-opencode {
        openAgentsControlSrc = inputs.OpenAgentsControl;
      };
    };
  };
}
