{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.noto
    ];
  };
}
