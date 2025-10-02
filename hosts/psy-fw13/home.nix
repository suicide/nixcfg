{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = let
    secrets = "${config.home.homeDirectory}/.config/sops-nix/secrets";
  in {
    __cfg = {
      sops.enable = true;

      hyprland = {
        enable = true;
        onStartup = let
          brightnessctl = lib.getExe pkgs.brightnessctl;
        in [
          "${brightnessctl} set 15%"
        ];
      };

      hypridle.keyboardBacklight = "framework_laptop::kbd_backlight";

      neovim = {
        enable = true;
        useLegacyConfig = false;
        useNvf = true;
        geminiApiKey = "${secrets}/ai/gemini/api_key";
      };
    };

    programs.git = {
      userName = "suiiii";
      userEmail = "suiiii@suiiii.rip";

      extraConfig = {
        user.signingkey = "2F1ACB1232E35B05";
      };
    };
  };
}
