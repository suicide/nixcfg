{lib, ...}: {
  options.internal.modules = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.deferredModule);
    default = {};
    description = "Reusable NixOS, nix-darwin, and Home Manager modules.";
  };

  config = {
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

    perSystem = {pkgs, ...}: {
      formatter = pkgs.alejandra;

      packages.yt-dlp-streamtape = pkgs.callPackage ../../packages/yt-dlp-streamtape {};
    };
  };
}
