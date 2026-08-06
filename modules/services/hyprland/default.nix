{
  inputs,
  lib,
  ...
}: {
  internal.modules = {
    # Existing NixOS hyprland service (cachix config).
    nixos.hyprland = {
      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };

    home.hyprland = {
      config,
      pkgs,
      inputs,
      lib,
      ...
    }: {
      imports = [
        ./_hyprland.nix
      ];
    };
  };

  # Verify that the shared Hyprland package helper applies the local glaze
  # patch exactly once (compositor + plugin rebuilt locally) while the portal
  # and all dependencies stay pristine/cacheable.
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    system = pkgs.stdenv.hostPlatform.system;

    checks = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux (let
      hyprlandPkgs = import ./_hyprland-packages.nix {inherit inputs pkgs;};
      unpatchedHyprland = inputs.hyprland.packages.${system}.hyprland;
      unpatchedPortal = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
      unpatchedSmw = inputs.hyprland-split-monitor-workspaces.packages.${system}.split-monitor-workspaces;
      plainHyprshot = pkgs.hyprshot;

      failures = builtins.filter (x: x != "") [
        (lib.optionalString (!(lib.elem ./glaze.patch (hyprlandPkgs.hyprland.patches or [])))
          "glaze.patch is not applied to the hyprland derivation")
        (lib.optionalString (hyprlandPkgs.hyprland.drvPath == unpatchedHyprland.drvPath)
          "hyprland derivation is not patched (drvPath unchanged)")
        (lib.optionalString (hyprlandPkgs.portal.drvPath != unpatchedPortal.drvPath)
          "portal derivation must stay unpatched/cacheable")
        (lib.optionalString (!(builtins.any (p: p ? drvPath && p.drvPath == hyprlandPkgs.hyprland.dev.drvPath) hyprlandPkgs.splitMonitorWorkspaces.buildInputs))
          "split-monitor-workspaces is not rebuilt against the patched hyprland.dev")
        (lib.optionalString (hyprlandPkgs.splitMonitorWorkspaces.drvPath == unpatchedSmw.drvPath)
          "split-monitor-workspaces derivation is not rebuilt (drvPath unchanged)")
        (lib.optionalString (hyprlandPkgs.hyprshot.drvPath == plainHyprshot.drvPath)
          "hyprshot is not overridden with the patched hyprland")
        (lib.optionalString (hyprlandPkgs.hyprshot.drvPath == (plainHyprshot.override {hyprland = unpatchedHyprland;}).drvPath)
          "hyprshot is overridden with the unpatched hyprland")
      ];
    in {
      hyprland-packages =
        pkgs.runCommand "hyprland-packages-check" {
          pass = failures == [];
          failMsg = lib.concatStringsSep "\n" failures;
        } ''
          if [ "$pass" != "1" ]; then
            echo "hyprland-packages assertions failed:" >&2
            echo "$failMsg" >&2
            exit 1
          fi
          echo ok > $out
        '';
    });
  in {
    inherit checks;
  };
}
