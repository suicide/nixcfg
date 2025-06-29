{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    __cfg.sops.enable = true;
    __cfg.hyprland.enable = true;

    __cfg.hypridle.keyboardBacklight = "framework_laptop::kbd_backlight";

    programs.git = {
      userName = "suiiii";
      userEmail = "suiiii@suiiii.rip";

      extraConfig = {
        user.signingkey = "2F1ACB1232E35B05";
      };
    };
  };
}
