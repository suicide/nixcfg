{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    __cfg.sops.enable = false;
    __cfg.hyprland.enable = false;
  };
}
