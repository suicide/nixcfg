{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = {
    __cfg.sops.enable = true;

    __cfg.hyprland = {
      enable = true;
      onStartup = let
        brightnessctl = lib.getExe pkgs.brightnessctl;
      in [
        "${brightnessctl} set 15%"
      ];
    };

    __cfg.hypridle.keyboardBacklight = "framework_laptop::kbd_backlight";

    programs.git = {
      userName = "suiiii";
      userEmail = "suiiii@suiiii.rip";

      extraConfig = {
        user.signingkey = "2F1ACB1232E35B05";
      };
    };

    __cfg.neovim = {
      enable = true;
      useLegacyConfig = false;
      useNvf = true;
    };
  };
}
