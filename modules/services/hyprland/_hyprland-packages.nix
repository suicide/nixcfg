# Shared Hyprland package set.
#
# Single source of truth for the Hyprland packages used across this
# configuration (NixOS programs.hyprland, Home Manager Hyprland, hyprshot and
# split-monitor-workspaces). The compositor is built from the pinned v0.56.2
# release tag plus a repo-local CMake patch (./glaze.patch) that drops the
# glaze version requirement, mirroring upstream commit 91f29f23. This
# intentionally makes Hyprland and anything built against its `dev` output
# (the split-monitor-workspaces plugin) compile locally instead of matching the
# upstream Cachix; all dependencies stay cacheable.
{
  inputs,
  pkgs,
}: let
  system = pkgs.stdenv.hostPlatform.system;

  # Unpatched upstream compositor; referenced only to swap it (and its dev
  # output) out of the plugin's buildInputs below.
  unpatchedHyprland = inputs.hyprland.packages.${system}.hyprland;

  # Patched compositor: v0.56.2 tag + glaze packaging fix.
  hyprland = unpatchedHyprland.overrideAttrs (old: {
    patches = (old.patches or []) ++ [./glaze.patch];
  });

  # xdg-desktop-portal-hyprland is unaffected by the glaze regression; keep it
  # pristine so it keeps matching the upstream Cachix.
  portal = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

  # The plugin builds against hyprland.dev, so it must be rebuilt against the
  # patched dev output to stay ABI-consistent with the compositor. Keep every
  # other upstream build input (pango, cairo and the compositor's own
  # buildInputs) and only swap the unpatched Hyprland outputs for the patched
  # dev output.
  splitMonitorWorkspaces = inputs.hyprland-split-monitor-workspaces.packages.${system}.split-monitor-workspaces.overrideAttrs (old: {
    buildInputs =
      (builtins.filter (p: p != unpatchedHyprland && p != unpatchedHyprland.dev) (old.buildInputs or []))
      ++ [hyprland.dev];
  });

  # hyprshot is wrapped against the same (patched) compositor binary.
  hyprshot = pkgs.hyprshot.override {inherit hyprland;};
in {
  inherit hyprland portal splitMonitorWorkspaces hyprshot;
}
