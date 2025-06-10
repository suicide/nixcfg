{ config, pkgs, inputs, ... }:
{
  config = {
    __cfg.sops.enable = true;
    __cfg.hyprland.enable = true;
  };
}
