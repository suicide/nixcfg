{...}: {
  internal.modules = {
    home.misc = {pkgs, ...}: {
      config = {
        home.packages = with pkgs; [
          btop
          htop
          dust
          yt-dlp
        ];
      };
    };
  };
}
