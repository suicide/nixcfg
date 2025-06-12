{ config, pkgs, inputs, ... }:
{
  config = {
    __cfg.sops.enable = true;
    __cfg.hyprland.enable = true;


    __cfg.hypridle.keyboardBacklight = "framework_laptop::kbd_backlight";

    programs.git = {
      userName = "suiiii";
      userEmail = "suiiii@suiiii.rip";

      extraConfig = {
        user.signingkey = "3A7A0EA9FE70D54C";
      };
    };
  };
}
